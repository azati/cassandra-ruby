module CassandraRuby
  module ApiWrapper
    include Thrift

    DEFAULT_CONSISTENCY_LEVEL = ConsistencyLevel::ONE
    DEFAULT_COLUMNS_OR_RANGE = { :start => '', :finish => '' }
    DEFAULT_KEY_RANGE = { :start_key => '', :end_key => '', :count => 100 }

    def get(keyspace, key, column_path, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      result = super(
        keyspace.to_s,
        key,
        cast_column_path(column_path),
        consistency_level)
      result.column || result.super_column
    end

    def get_slice(keyspace, key, column_parent, columns_or_range = DEFAULT_COLUMNS_OR_RANGE, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      result = super(
        keyspace.to_s,
        key,
        cast_column_parent(column_parent),
        cast_slice_predicate(columns_or_range),
        consistency_level)
      result.map! { |c| c.column || c.super_column }
    end

    def multiget_slice(keyspace, keys, column_parent, columns_or_range = DEFAULT_COLUMNS_OR_RANGE, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      result = super(
        keyspace.to_s,
        keys,
        cast_column_parent(column_parent),
        cast_slice_predicate(columns_or_range),
        consistency_level)
      result.each_value do |value|
        value.map! { |c| c.column || c.super_column }
      end
    end

    def get_count(keyspace, key, column_parent, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      super(
        keyspace.to_s,
        key,
        cast_column_parent(column_parent),
        consistency_level)
    end

    def get_range_slices(keyspace, column_parent, columns_or_range = DEFAULT_COLUMNS_OR_RANGE, key_range = DEFAULT_KEY_RANGE, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      result = super(
        keyspace.to_s,
        cast_column_parent(column_parent),
        cast_slice_predicate(columns_or_range),
        cast_key_range(key_range),
        consistency_level)
      result.map! do |key_slice|
        key_slice.columns.map! { |c| c.column || c.super_column }
        { key_slice.key => key_slice.columns }
      end
    end

    def insert(keyspace, key, column_path, value, timestamp, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      super(
        keyspace.to_s,
        key,
        cast_column_path(column_path),
        value,
        timestamp,
        consistency_level)
    end

    def remove(keyspace, key, column_path, timestamp, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      super(
        keyspace.to_s,
        key,
        cast_column_path(column_path),
        timestamp,
        consistency_level)
    end

    def batch_mutate(keyspace, mutation_map, consistency_level = DEFAULT_CONSISTENCY_LEVEL)
      super(
        keyspace.to_s,
        cast_mutation_map(mutation_map),
        consistency_level)
    end

    def describe_keyspaces
      result = super
      result.reject!{ |k| k == 'system' }.map!(&:to_sym)
    end

    def describe_cluster_name
      super
    end

    def describe_version
      super
    end

    def describe_ring(keyspace)
      super(keyspace.to_s)
    end

    def describe_keyspace(keyspace)
      super(keyspace.to_s)
    end

    protected

    def cast_column_path(arg)
      column_family, super_column, column = *arg
      column, super_column = super_column, nil if column.nil?
      ColumnPath.new(
        :column_family => column_family,
        :super_column => super_column,
        :column => column
      )
    end

    def cast_column_parent(arg)
      column_family, super_column = *arg.to_a
      ColumnPath.new(
        :column_family => column_family,
        :super_column => super_column
      )
    end

    def cast_slice_predicate(arg)
      if arg.is_a?(Hash)
        SlicePredicate.new(:slice_range => SliceRange.new(arg))
      else
        SlicePredicate.new(:column_names => arg.to_a)
      end
    end

    def cast_key_range(arg)
      KeyRange.new(arg)
    end

    def cast_mutation_map(arg)
      arg.each_value do |family_mutations|
        family_mutations.each_value do |mutations|
          mutations.map! { |mutation| cast_mutation(mutation) }
        end
      end
    end

    def cast_mutation(arg)
      result = Mutation.new()

      case arg
      when Column
        result.column_or_supercolumn = ColumnOrSuperColumn.new(:column => arg)
      when SuperColumn
        result.column_or_supercolumn = ColumnOrSuperColumn.new(:super_column => arg)
      when Hash
        result.deletion = cast_deletion(arg)
      else
        raise 'Only Column, SuperColumn and Deletion are available for mutations'
      end

      result
    end

    def cast_deletion(arg)
      Deletion.new(
        :timestamp    => arg[:timestamp],
        :super_column => arg[:super_column],
        :predicate    => cast_slice_predicate(arg[:delete])
      )
    end
  end
end