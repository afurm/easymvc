class PostMapper < EasyMvc::Mapper
  @@table_name = "posts"
  @@model = Post
  @@mapping = {
      id: :id,
      header: :title,
      content: :body,
      created_at: :created_at
  }

  def created_at
    @model.created_at.to_s
  end
end