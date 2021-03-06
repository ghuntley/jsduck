require 'strscan'

module JsDuck

  # Validates the syntax of type definitions
  #
  # Quick summary of supported types:
  #
  # - SomeType
  # - Name.spaced.Type
  # - Number[]
  # - String/RegExp
  # - Type...
  #
  # Details are covered in spec.
  #
  class TypeParser
    # Allows to check the type of error that was encountered.
    # It will be either of the two:
    # - :syntax - type definition syntax is incorrect
    # - :name - one of the names of the types is unknown
    attr_reader :error

    # Initializes the parser with hash of valid type names
    def initialize(relations={})
      @relations = relations
      @builtins = {
        # JavaScript builtins
        "Object" => true,
        "String" => true,
        "Number" => true,
        "Boolean" => true,
        "RegExp" => true,
        "Function" => true,
        "Array" => true,
        "Arguments" => true,
        "Date" => true,
        "Error" => true,
        "undefined" => true,
        # DOM
        "HTMLElement" => true,
        "XMLElement" => true,
        "NodeList" => true,
        "TextNode" => true,
        "CSSStyleSheet" => true,
        "CSSStyleRule" => true,
        "Event" => true,
      }
    end

    def parse(str)
      @input = StringScanner.new(str)
      @error = :syntax

      # Return immediately if base type doesn't match
      return false unless base_type

      # Go through enumeration of types, separated with "/"
      while @input.check(/\//)
        @input.scan(/\//)
        # Fail if there's no base type after "/"
        return false unless base_type
      end

      # The definition might end with an ellipsis
      @input.scan(/\.\.\./)

      # Success if we have reached the end of input
      return @input.eos?
    end

    # The basic type
    #
    #     <ident> [ "." <ident> ]* [ "[]" ]
    #
    # dot-separated identifiers followed by optional "[]"
    def base_type
      type = @input.scan(/[a-zA-Z_]+(\.[a-zA-Z_]+)*(\[\])?/)
      return type && exists?(type)
    end

    def exists?(type)
      stype = type.sub(/\[\]$/, "")
      if @builtins[stype] || @relations[stype]
        true
      else
        @error = :name
        false
      end
    end

  end

end
