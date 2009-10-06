module Resourceful
    
  # The idea here is to take a collection of object instances that have resourceful associations and
  # => for each association specified
  #   => get the foreign key name
  #   => get the foreign key values for each item in the collection
  #   => grab the data for all the foreign keys in one call
  #   => build object for each result in data
  #   => for each item in the collection, set it's association value from built objects
  def self.eager_load(collection, associations)
    if (collection.respond_to?('each') && (collection.respond_to?('empty?') && !collection.empty?)) && \
       (associations.respond_to?('each') && (associations.respond_to?('empty?') && !associations.empty?))
      klass = collection.first.class
      associations.each do |association_name|
        clean_association_name = Resourceful::Model::Base.cleanup_name(association_name.to_s)
        assoc_data = get_association_data(klass, clean_association_name)
        assoc_klass = klass.ancestors.include?(Resourceful::Model::Base) ? klass.get_namespaced_klass(assoc_data[:class_name]) : assoc_data[:class_name].resourceful_constantize
        fk_values = collection.inject([]) {|vals, item| vals << item.send(assoc_data[:foreign_key_method])}
        fk_results = assoc_klass.send(assoc_data[:find_method_name], :all, {assoc_data[:foreign_key_name] => fk_values.join(',')}, true)
        collection.each do |item|
          item_results = fk_results.reject{|result| result.send(assoc_data[:foreign_key_name]) != item.send(assoc_data[:foreign_key_method])}
          item.instance_variable_set("@#{clean_association_name}", [:belongs_to, :has_one].include?(assoc_data[:type]) ? item_results.first : item_results)
        end
      end
    end
    collection
  end

  def self.add_to_associations(klass_name, name, data)
    @@resourceful_associations ||= {}
    @@resourceful_associations[klass_name] ||= {}
    @@resourceful_associations[klass_name][name] = data
  end
  def self.get_association_data(klass, name)
    @@resourceful_associations ||= {}
    assoc_data = nil
    klass.ancestors.each do |anc|
      break if @@resourceful_associations[anc.to_s] && (assoc_data = @@resourceful_associations[anc.to_s][name])
    end
    assoc_data
  end

end