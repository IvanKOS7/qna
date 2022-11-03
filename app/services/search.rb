class Services::Search
   SCOPES = %w[thinking_sphinx user comment question answer].freeze

   attr_accessor :items, :meta_hash

   def initialize
     @meta = meta
     @items = items
   end

   def call(query)
     return unless SCOPES.include?(query['scope'])
     escaped_query = ThinkingSphinx::Query.escape(query['query'])
     klass = query['scope'].classify.constantize
     self.items = klass.search(escaped_query)
     # meta
   end

   def meta
     # self.meta_hash = ThinkingSphinx.search.meta.to_h
   end
 end
