FunctionNode = Struct.new(:name, :args, :body)
FunctionCallNode = Struct.new(:name, :arg_expressions)
IntegerNode = Struct.new(:value)
VariableReferenceNode = Struct.new(:value)

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def consume_token(expected_type)
    # Shift first token in token array
    consumed_token = @tokens.shift
    # Compare token's type to an expected type
    if consumed_token.type == expected_type
      return consumed_token
    else
      raise RuntimeError.new(
        "Expected token type #{expected_type.inspect} but got #{consumed_token.type.inspect}"
      )
    end
  end

  def peek(expected_type, offset=0)
    @tokens.fetch(offset).type == expected_type
  end

  def parse_input_args
    args = []
    consume_token(:lpa)
    if peek(:var)
      args << consume_token(:var).value
      # Parse any number of input arguments
      while peek(:com)
        consume_token(:com)
        args << consume_token(:var).value
      end
    end
    consume_token(:rpa)
    return args
  end

  def parse_call_args
    call_args = []
    consume_token(:lpa)
    if !peek(:rpa)
      # Circular dependency into parse_function_call
      call_args << parse_expression
      # Parse all expressions passed to function call
      while peek(:com)
        consume_token(:com)
        call_args << parse_expression
      end
    end
    consume_token(:rpa)
    return call_args
  end

  def parse_function_call
    call_name = consume_token(:var)
    # Circular dependency into parse_expression
    call_args = parse_call_args
    return FunctionCallNode.new(call_name, call_args)
  end

  def parse_expression
    def parse_integer_expression
      # Cast to Ruby-integer
      return IntegerNode.new(consume_token(:int).value.to_i)
    end

    def parse_variable_reference
      return VariableReferenceNode.new(consume_token(:var).value)
    end

    if peek(:int)
      return parse_integer_expression
    elsif peek(:var) && peek(:lpa, 1)
      # Circular dependency into parse_call_args
      return parse_function_call
    else
      return parse_variable_reference
    end
  end

  def parse_function_definition
    consume_token(:def)
    function_name = consume_token(:var).value
    input_args = parse_input_args
    function_body = parse_expression
    consume_token(:end)

    puts "Done parsing function definition"
    return FunctionNode.new(function_name, input_args, function_body)
  end

  def parse
    parse_function_definition
  end
end
