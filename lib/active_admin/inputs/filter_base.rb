module ActiveAdmin
  module Inputs
    module FilterBase
      include ::Formtastic::Inputs::Base

      def input_wrapping(&block)
        template.content_tag(:div,
          template.capture(&block),
          wrapper_html_options
        )
      end

      def required?
        false
      end

      def wrapper_html_options
        { :class => "filter_form_field #{as}" }
      end

      # Override the standard finder to accept a proc
      def collection_from_options
        if options[:collection].is_a?(Proc)
          template.instance_eval(&options[:collection])
        else
          super
        end
      end

      # Returns the default label for a given attribute
      # Will use ActiveModel I18n if possible
      def humanized_method_name
        if base.respond_to?(:human_attribute_name)
          base.human_attribute_name(method)
        else
          method.to_s.send(builder.label_str_method)
        end
      end

      # Returns the association reflection for the method if it exists
      def reflection_for(method)
        base.reflect_on_association(method) if base.respond_to?(:reflect_on_association)
      end
      
      def base
        @object.base if @object
      end
      
    end
  end
end
