#!/usr/local/bin/ruby

require "stringio"

class ParserError < StandardError
  def initialize(msg = "Parser Error")
    super
  end
end

class InvalidTokenError < ParserError
  def initialize(token = nil, msg = "Invalid token")
    @token = token
    msg << ": #{token}" if token
    super(msg)
end

class Parser
  def initialize
    @rules = {}
    @token = nil
    @buffer = []
    yield self if block_given?
  end

  def rule(r)
    match = r.match(/( ?)(->|:)\1/)
    pre,post = match.pre_match, match.post_match.split(/ ?| ?/)
    if post.find {|s| s =~ /^#{pre}/}
      issues = post.select {|s| s =~ /^#{pre}/}
      others = post - issues
    
       
    else
      @rules[pre] = post
    end
  end

  def error
    raise InvalidTokenError.new(@token)
  end

  def get_token
    if buffer.empty?
      line = gets
      @buffer = line.split(" ") if line
    end
    @token = @buffer[0]
  end

  def parse
    get_token
    self.is_S
    if @token
      error
    else
      return true
    end
  end
end
