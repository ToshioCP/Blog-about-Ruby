
class Calc
  include Math

  def initialize
    @table = {}
    @value = 0.0
  end

  # calculate s
  # error => return error message
  # success => return the result as a string
  def run(s)
    a = parse(s)
    if a.instance_of? Float
      @value = a # keep the result of the calcukation.
      a = a.to_i if a.to_i == a
    end
    a.to_s
  end

  # error => return nil
  # success => return array like:
  # [[:id, "var"], [:=, nil], [:num, 12.34], [:+, nil], ... ... ...]
  def lex(s)
    result = []
    while true
      break if s == ""
      case s[0]
      when /[[:alpha:]]/
        m = /\A([[:alpha:]]+)(.*)\Z/m.match(s)
        name = m[1]; s = m[2]
        if name =~ /sin|cos|tan|asin|acos|atan|exp|log|sqrt|PI|E|v/
          result << [$&.to_sym, nil]
        else
          result << [:id, name]
        end
      when /[[:digit:]]/
        m = /\A([[:digit:]]+(\.[[:digit:]]*)?)(.*)\Z/m.match(s)
        result << [:num, m[1].to_f]
        s = m[3]
      when /[+\-*\/()=]/
        if s =~ /^\*\*/
          result << [s[0,2].to_sym,nil]
          s = s[2..-1]
        else
          result << [s[0].to_sym, nil]
          s = s[1..-1]
        end
      when /\s/
        s = s[1..-1] 
      else
        @error_message = "Unexpected character."
        result = nil
        s = "" # remove the rest of the string.
      end
    end
    result
  end

  # BNF
  # program: statement;
  # statement: ID '=' expression
  #   | expression
  #   ;
  # expression: expression '+' factor1
  #   | expression '-' factor1
  #   | factor0
  #   ;
  # factor0: factor1
  #   | '-' factor1
  #   ;
  # factor1: factor1 '*' power
  #   | factor1 '/' power
  #   | power
  #   ;
  # power: primary ** power
  #   | primary
  #   ;
  # primary: NUM | 'PI' | 'E' | '(' expression ')' | function '(' expression ')' | 'v';
  # function: 'sin' | 'cos' | 'tan' | 'asin' | 'acos' | 'atan' | 'exp' | 'log' ;

  # parser
  # error => return error message
  # success => return the result of the calculation (Float)
  def parse(s)
    tokens = lex(s)
    return @error_message unless tokens # lex error
    tokens.reverse!
    a = statement(tokens) # error
    return "syntax error." unless tokens == []
    a ? a : @error_message
  end

  private

  # error => return false and the error message is assigned to @error_message
  # success => return the result of the calculation (Float)
  def statement(tokens)
    token = tokens.pop.to_a
    case token[0]
    when :id
      a = token[1]
      b = tokens.pop.to_a
      if  b[0] == :'='
        return false unless c = expression(tokens)
        install(a, c)
        c
      else
        tokens.push(b) if b[0]
        tokens.push(token)
        expression(tokens)
      end
    when nil # token is now empty.
      syntax_error
      false
    else
      tokens.push(token)
      expression(tokens)
    end
  end

  def expression(tokens)
    return false unless (a = factor0(tokens))
    while true
      token = tokens.pop.to_a
      case token[0]
      when :'+'
        b = factor1(tokens)
        unless b
          break false
        end
        a = a+b
      when :'-'
        b = factor1(tokens)
        unless b
          break false
        end
        a = a-b
      when nil
        return a
      else
        tokens.push(token)
        break a
      end
    end
  end

  def factor0(tokens)
    token = tokens.pop.to_a
    case token[0]
    when :'-'
      b = factor1(tokens)
      b ? -b : false
    when nil
      syntax_error
      false
    else
      tokens.push(token)
      factor1(tokens)
    end
  end

  def factor1(tokens)
    return false unless (a = power(tokens))
    while true
      token = tokens.pop.to_a
      case token[0]
      when :'*'
        b = power(tokens)
        unless b
          break false
        end
        a = a*b
      when :'/'
        b = power(tokens)
        unless b
          break false
        end
        if b == 0
          @error_message = "Division by 0.\n"
          break false
        end
        a = a/b
      when nil
        break a
      else
        tokens.push(token)
        break a
      end
    end
  end

  def power(tokens)
    return false unless (a = primary(tokens))
    token = tokens.pop.to_a
    case token[0]
    when :'**'
      b = power(tokens)
      if b
        a**b
      else
        false
      end
    when nil
      a
    else
      tokens.push(token)
      a
    end
  end

  def primary(tokens)
    token = tokens.pop.to_a
    case token[0]
    when :id
      a = lookup(token[1])
      @error_message = "Variable #{token[1]} not defined.\n" unless a
      a ? a : false
    when :num
      token[1]
    when :PI
      PI
    when :E
      E
    when :'('
      b = expression(tokens)
      return false unless b
      unless tokens.pop.to_a[0] == :')'
        syntax_error
        return false
      end
      b
    when :sin, :cos, :tan, :asin, :acos, :atan, :exp, :log, :sqrt
      f = token[0]
      unless tokens.pop.to_a[0] == :'('
        syntax_error
        return false
      end
      b = expression(tokens)
      return false unless b
      unless tokens.pop.to_a[0] == :')'
        syntax_error
        return false
      end
      method(f).call(b)
    when :v
      @value
    when nil
      syntax_error
      false
    else
      syntax_error
      false
    end
  end

  def install(name, value)
    @table[name] = value
  end
  def lookup(name)
    @table[name]
  end

  def syntax_error
    @error_message = "syntax error."
  end
end
