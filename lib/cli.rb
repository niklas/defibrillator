class Cli

  def self.update(*argv)
    klass_name = argv.shift
    raise ArgumentError, "only projects allowed to update (for now)" unless klass_name === 'Project'
    klass = klass_name.classify.constantize

    name = argv.shift
    object = klass.find_or_create_by_name name

    object.update_attributes_from_shell(*argv)
  end

  module UpdatesFromShell
    def update_attributes_from_shell(*argv)
      new_attr = parse_attributes_from_shell(*argv)
      update_attributes new_attr
    end

    def parse_attributes_from_shell(*argv)
      new_attr = argv.inject({}) do |hash, arg|
        key, val = arg.split(':')
        val = $1 if val =~ %r~^"([^"]+)"$~
        val = $1 if val =~ %r~^'([^']+)'$~
        if key && val
          hash[key] = val
        end
        hash
      end
    end

  end

end
