module CassandraRuby
  module Thrift
    class Client
      include ::Thrift::Client

      def login(keyspace, auth_request)
        send_login(keyspace, auth_request)
        recv_login()
      end

      def get(keyspace, key, column_path, consistency_level)
        send_get(keyspace, key, column_path, consistency_level)
        return recv_get()
      end

      def get_slice(keyspace, key, column_parent, predicate, consistency_level)
        send_get_slice(keyspace, key, column_parent, predicate, consistency_level)
        return recv_get_slice()
      end
      
      def multiget_slice(keyspace, keys, column_parent, predicate, consistency_level)
        send_multiget_slice(keyspace, keys, column_parent, predicate, consistency_level)
        return recv_multiget_slice()
      end

      def get_count(keyspace, key, column_parent, consistency_level)
        send_get_count(keyspace, key, column_parent, consistency_level)
        return recv_get_count()
      end

      def get_range_slices(keyspace, column_parent, predicate, range, consistency_level)
        send_get_range_slices(keyspace, column_parent, predicate, range, consistency_level)
        return recv_get_range_slices()
      end

      def insert(keyspace, key, column_path, value, timestamp, consistency_level)
        send_insert(keyspace, key, column_path, value, timestamp, consistency_level)
        recv_insert()
      end

      def remove(keyspace, key, column_path, timestamp, consistency_level)
        send_remove(keyspace, key, column_path, timestamp, consistency_level)
        recv_remove()
      end

      def batch_mutate(keyspace, mutation_map, consistency_level)
        send_batch_mutate(keyspace, mutation_map, consistency_level)
        recv_batch_mutate()
      end

      def describe_keyspaces()
        send_describe_keyspaces()
        return recv_describe_keyspaces()
      end

      def describe_cluster_name()
        send_describe_cluster_name()
        return recv_describe_cluster_name()
      end

      def describe_version()
        send_describe_version()
        return recv_describe_version()
      end

      def describe_ring(keyspace)
        send_describe_ring(keyspace)
        return recv_describe_ring()
      end

      def describe_keyspace(keyspace)
        send_describe_keyspace(keyspace)
        return recv_describe_keyspace()
      end

      def describe_splits(start_token, end_token, keys_per_split)
        send_describe_splits(start_token, end_token, keys_per_split)
        return recv_describe_splits()
      end

      protected

      def send_login(keyspace, auth_request)
        send_message('login', Login_args, :keyspace => keyspace, :auth_request => auth_request)
      end

      def recv_login()
        result = receive_message(Login_result)
        raise result.authnx unless result.authnx.nil?
        raise result.authzx unless result.authzx.nil?
        return
      end

      def send_get(keyspace, key, column_path, consistency_level)
        send_message('get', Get_args, :keyspace => keyspace, :key => key, :column_path => column_path, :consistency_level => consistency_level)
      end

      def recv_get()
        result = receive_message(Get_result)
        return result.success unless result.success.nil?
        raise result.ire unless result.ire.nil?
        raise result.nfe unless result.nfe.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get failed: unknown result')
      end

      def send_get_slice(keyspace, key, column_parent, predicate, consistency_level)
        send_message('get_slice', Get_slice_args, :keyspace => keyspace, :key => key, :column_parent => column_parent, :predicate => predicate, :consistency_level => consistency_level)
      end

      def recv_get_slice()
        result = receive_message(Get_slice_result)
        return result.success unless result.success.nil?
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get_slice failed: unknown result')
      end

      def send_multiget_slice(keyspace, keys, column_parent, predicate, consistency_level)
        send_message('multiget_slice', Multiget_slice_args, :keyspace => keyspace, :keys => keys, :column_parent => column_parent, :predicate => predicate, :consistency_level => consistency_level)
      end

      def recv_multiget_slice()
        result = receive_message(Multiget_slice_result)
        return result.success unless result.success.nil?
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'multiget_slice failed: unknown result')
      end

      def send_get_count(keyspace, key, column_parent, consistency_level)
        send_message('get_count', Get_count_args, :keyspace => keyspace, :key => key, :column_parent => column_parent, :consistency_level => consistency_level)
      end

      def recv_get_count()
        result = receive_message(Get_count_result)
        return result.success unless result.success.nil?
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get_count failed: unknown result')
      end

      def send_get_range_slices(keyspace, column_parent, predicate, range, consistency_level)
        send_message('get_range_slices', Get_range_slices_args, :keyspace => keyspace, :column_parent => column_parent, :predicate => predicate, :range => range, :consistency_level => consistency_level)
      end

      def recv_get_range_slices()
        result = receive_message(Get_range_slices_result)
        return result.success unless result.success.nil?
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'get_range_slices failed: unknown result')
      end

      def send_insert(keyspace, key, column_path, value, timestamp, consistency_level)
        send_message('insert', Insert_args, :keyspace => keyspace, :key => key, :column_path => column_path, :value => value, :timestamp => timestamp, :consistency_level => consistency_level)
      end

      def recv_insert()
        result = receive_message(Insert_result)
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        return
      end

      def send_describe_splits(start_token, end_token, keys_per_split)
        send_message('describe_splits', Describe_splits_args, :start_token => start_token, :end_token => end_token, :keys_per_split => keys_per_split)
      end

      def recv_describe_splits()
        result = receive_message(Describe_splits_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_splits failed: unknown result')
      end

      def send_describe_keyspace(keyspace)
        send_message('describe_keyspace', Describe_keyspace_args, :keyspace => keyspace)
      end

      def recv_describe_keyspace()
        result = receive_message(Describe_keyspace_result)
        return result.success unless result.success.nil?
        raise result.nfe unless result.nfe.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_keyspace failed: unknown result')
      end

      def send_describe_ring(keyspace)
        send_message('describe_ring', Describe_ring_args, :keyspace => keyspace)
      end

      def recv_describe_ring()
        result = receive_message(Describe_ring_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_ring failed: unknown result')
      end

      def send_remove(keyspace, key, column_path, timestamp, consistency_level)
        send_message('remove', Remove_args, :keyspace => keyspace, :key => key, :column_path => column_path, :timestamp => timestamp, :consistency_level => consistency_level)
      end

      def recv_remove()
        result = receive_message(Remove_result)
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        return
      end

      def send_batch_mutate(keyspace, mutation_map, consistency_level)
        send_message('batch_mutate', Batch_mutate_args, :keyspace => keyspace, :mutation_map => mutation_map, :consistency_level => consistency_level)
      end

      def recv_batch_mutate()
        result = receive_message(Batch_mutate_result)
        raise result.ire unless result.ire.nil?
        raise result.ue unless result.ue.nil?
        raise result.te unless result.te.nil?
        return
      end

      def send_describe_keyspaces()
        send_message('describe_keyspaces', Describe_keyspaces_args)
      end

      def recv_describe_keyspaces()
        result = receive_message(Describe_keyspaces_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_keyspaces failed: unknown result')
      end

      def send_describe_cluster_name()
        send_message('describe_cluster_name', Describe_cluster_name_args)
      end

      def recv_describe_cluster_name()
        result = receive_message(Describe_cluster_name_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_cluster_name failed: unknown result')
      end

      def send_describe_version()
        send_message('describe_version', Describe_version_args)
      end

      def recv_describe_version()
        result = receive_message(Describe_version_result)
        return result.success unless result.success.nil?
        raise ::Thrift::ApplicationException.new(::Thrift::ApplicationException::MISSING_RESULT, 'describe_version failed: unknown result')
      end
    end

    # HELPER FUNCTIONS AND STRUCTURES

    class Login_args
      include ::Thrift::Struct
      KEYSPACE = 1
      AUTH_REQUEST = 2

      ::Thrift::Struct.field_accessor self, :keyspace, :auth_request
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        AUTH_REQUEST => {:type => ::Thrift::Types::STRUCT, :name => 'auth_request', :class => AuthenticationRequest}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field auth_request is unset!') unless @auth_request
      end

    end

    class Login_result
      include ::Thrift::Struct
      AUTHNX = 1
      AUTHZX = 2

      ::Thrift::Struct.field_accessor self, :authnx, :authzx
      FIELDS = {
        AUTHNX => {:type => ::Thrift::Types::STRUCT, :name => 'authnx', :class => AuthenticationException},
        AUTHZX => {:type => ::Thrift::Types::STRUCT, :name => 'authzx', :class => AuthorizationException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Get_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEY = 2
      COLUMN_PATH = 3
      CONSISTENCY_LEVEL = 4

      ::Thrift::Struct.field_accessor self, :keyspace, :key, :column_path, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
        COLUMN_PATH => {:type => ::Thrift::Types::STRUCT, :name => 'column_path', :class => ColumnPath},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_path is unset!') unless @column_path
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Get_result
      include ::Thrift::Struct
      SUCCESS = 0
      IRE = 1
      NFE = 2
      UE = 3
      TE = 4

      ::Thrift::Struct.field_accessor self, :success, :ire, :nfe, :ue, :te
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRUCT, :name => 'success', :class => ColumnOrSuperColumn},
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        NFE => {:type => ::Thrift::Types::STRUCT, :name => 'nfe', :class => NotFoundException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Get_slice_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEY = 2
      COLUMN_PARENT = 3
      PREDICATE = 4
      CONSISTENCY_LEVEL = 5

      ::Thrift::Struct.field_accessor self, :keyspace, :key, :column_parent, :predicate, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
        COLUMN_PARENT => {:type => ::Thrift::Types::STRUCT, :name => 'column_parent', :class => ColumnParent},
        PREDICATE => {:type => ::Thrift::Types::STRUCT, :name => 'predicate', :class => SlicePredicate},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_parent is unset!') unless @column_parent
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field predicate is unset!') unless @predicate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Get_slice_result
      include ::Thrift::Struct
      SUCCESS = 0
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :success, :ire, :ue, :te
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => ColumnOrSuperColumn}},
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Multiget_slice_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEYS = 2
      COLUMN_PARENT = 3
      PREDICATE = 4
      CONSISTENCY_LEVEL = 5

      ::Thrift::Struct.field_accessor self, :keyspace, :keys, :column_parent, :predicate, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEYS => {:type => ::Thrift::Types::LIST, :name => 'keys', :element => {:type => ::Thrift::Types::STRING}},
        COLUMN_PARENT => {:type => ::Thrift::Types::STRUCT, :name => 'column_parent', :class => ColumnParent},
        PREDICATE => {:type => ::Thrift::Types::STRUCT, :name => 'predicate', :class => SlicePredicate},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keys is unset!') unless @keys
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_parent is unset!') unless @column_parent
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field predicate is unset!') unless @predicate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Multiget_slice_result
      include ::Thrift::Struct
      SUCCESS = 0
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :success, :ire, :ue, :te
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::STRUCT, :class => ColumnOrSuperColumn}}},
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end
    end

    class Get_count_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEY = 2
      COLUMN_PARENT = 3
      CONSISTENCY_LEVEL = 4

      ::Thrift::Struct.field_accessor self, :keyspace, :key, :column_parent, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
        COLUMN_PARENT => {:type => ::Thrift::Types::STRUCT, :name => 'column_parent', :class => ColumnParent},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_parent is unset!') unless @column_parent
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Get_count_result
      include ::Thrift::Struct
      SUCCESS = 0
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :success, :ire, :ue, :te
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::I32, :name => 'success'},
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Get_range_slices_args
      include ::Thrift::Struct
      KEYSPACE = 1
      COLUMN_PARENT = 2
      PREDICATE = 3
      RANGE = 4
      CONSISTENCY_LEVEL = 5

      ::Thrift::Struct.field_accessor self, :keyspace, :column_parent, :predicate, :range, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        COLUMN_PARENT => {:type => ::Thrift::Types::STRUCT, :name => 'column_parent', :class => ColumnParent},
        PREDICATE => {:type => ::Thrift::Types::STRUCT, :name => 'predicate', :class => SlicePredicate},
        RANGE => {:type => ::Thrift::Types::STRUCT, :name => 'range', :class => KeyRange},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_parent is unset!') unless @column_parent
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field predicate is unset!') unless @predicate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field range is unset!') unless @range
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Get_range_slices_result
      include ::Thrift::Struct
      SUCCESS = 0
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :success, :ire, :ue, :te
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => KeySlice}},
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Insert_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEY = 2
      COLUMN_PATH = 3
      VALUE = 4
      TIMESTAMP = 5
      CONSISTENCY_LEVEL = 6

      ::Thrift::Struct.field_accessor self, :keyspace, :key, :column_path, :value, :timestamp, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
        COLUMN_PATH => {:type => ::Thrift::Types::STRUCT, :name => 'column_path', :class => ColumnPath},
        VALUE => {:type => ::Thrift::Types::STRING, :name => 'value'},
        TIMESTAMP => {:type => ::Thrift::Types::I64, :name => 'timestamp'},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_path is unset!') unless @column_path
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field value is unset!') unless @value
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field timestamp is unset!') unless @timestamp
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Insert_result
      include ::Thrift::Struct
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :ire, :ue, :te
      FIELDS = {
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Remove_args
      include ::Thrift::Struct
      KEYSPACE = 1
      KEY = 2
      COLUMN_PATH = 3
      TIMESTAMP = 4
      CONSISTENCY_LEVEL = 5

      ::Thrift::Struct.field_accessor self, :keyspace, :key, :column_path, :timestamp, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        KEY => {:type => ::Thrift::Types::STRING, :name => 'key'},
        COLUMN_PATH => {:type => ::Thrift::Types::STRUCT, :name => 'column_path', :class => ColumnPath},
        TIMESTAMP => {:type => ::Thrift::Types::I64, :name => 'timestamp'},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field key is unset!') unless @key
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field column_path is unset!') unless @column_path
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field timestamp is unset!') unless @timestamp
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Remove_result
      include ::Thrift::Struct
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :ire, :ue, :te
      FIELDS = {
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Batch_mutate_args
      include ::Thrift::Struct
      KEYSPACE = 1
      MUTATION_MAP = 2
      CONSISTENCY_LEVEL = 3

      ::Thrift::Struct.field_accessor self, :keyspace, :mutation_map, :consistency_level
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'},
        MUTATION_MAP => {:type => ::Thrift::Types::MAP, :name => 'mutation_map', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::MAP, :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::STRUCT, :class => Mutation}}}},
        CONSISTENCY_LEVEL => {:type => ::Thrift::Types::I32, :name => 'consistency_level', :default =>             1, :enum_class => ConsistencyLevel}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field mutation_map is unset!') unless @mutation_map
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field consistency_level is unset!') unless @consistency_level
        unless @consistency_level.nil? || ConsistencyLevel::VALID_VALUES.include?(@consistency_level)
          raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field consistency_level!')
        end
      end

    end

    class Batch_mutate_result
      include ::Thrift::Struct
      IRE = 1
      UE = 2
      TE = 3

      ::Thrift::Struct.field_accessor self, :ire, :ue, :te
      FIELDS = {
        IRE => {:type => ::Thrift::Types::STRUCT, :name => 'ire', :class => InvalidRequestException},
        UE => {:type => ::Thrift::Types::STRUCT, :name => 'ue', :class => UnavailableException},
        TE => {:type => ::Thrift::Types::STRUCT, :name => 'te', :class => TimedOutException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_keyspaces_args
      include ::Thrift::Struct

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_keyspaces_result
      include ::Thrift::Struct
      SUCCESS = 0

      ::Thrift::Struct.field_accessor self, :success
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::SET, :name => 'success', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_cluster_name_args
      include ::Thrift::Struct

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_cluster_name_result
      include ::Thrift::Struct
      SUCCESS = 0

      ::Thrift::Struct.field_accessor self, :success
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_version_args
      include ::Thrift::Struct

      FIELDS = {

      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_version_result
      include ::Thrift::Struct
      SUCCESS = 0

      ::Thrift::Struct.field_accessor self, :success
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::STRING, :name => 'success'}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_ring_args
      include ::Thrift::Struct
      KEYSPACE = 1

      ::Thrift::Struct.field_accessor self, :keyspace
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
      end

    end

    class Describe_ring_result
      include ::Thrift::Struct
      SUCCESS = 0

      ::Thrift::Struct.field_accessor self, :success
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRUCT, :class => TokenRange}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_keyspace_args
      include ::Thrift::Struct
      KEYSPACE = 1

      ::Thrift::Struct.field_accessor self, :keyspace
      FIELDS = {
        KEYSPACE => {:type => ::Thrift::Types::STRING, :name => 'keyspace'}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keyspace is unset!') unless @keyspace
      end

    end

    class Describe_keyspace_result
      include ::Thrift::Struct
      SUCCESS = 0
      NFE = 1

      ::Thrift::Struct.field_accessor self, :success, :nfe
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::MAP, :name => 'success', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::MAP, :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRING}}},
        NFE => {:type => ::Thrift::Types::STRUCT, :name => 'nfe', :class => NotFoundException}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

    class Describe_splits_args
      include ::Thrift::Struct
      START_TOKEN = 1
      END_TOKEN = 2
      KEYS_PER_SPLIT = 3

      ::Thrift::Struct.field_accessor self, :start_token, :end_token, :keys_per_split
      FIELDS = {
        START_TOKEN => {:type => ::Thrift::Types::STRING, :name => 'start_token'},
        END_TOKEN => {:type => ::Thrift::Types::STRING, :name => 'end_token'},
        KEYS_PER_SPLIT => {:type => ::Thrift::Types::I32, :name => 'keys_per_split'}
      }

      def struct_fields; FIELDS; end

      def validate
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field start_token is unset!') unless @start_token
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field end_token is unset!') unless @end_token
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Required field keys_per_split is unset!') unless @keys_per_split
      end

    end

    class Describe_splits_result
      include ::Thrift::Struct
      SUCCESS = 0

      ::Thrift::Struct.field_accessor self, :success
      FIELDS = {
        SUCCESS => {:type => ::Thrift::Types::LIST, :name => 'success', :element => {:type => ::Thrift::Types::STRING}}
      }

      def struct_fields; FIELDS; end

      def validate
      end

    end

  end
end