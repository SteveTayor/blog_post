const String fetchAllBlogs = r'''
  query fetchAllBlogs {
    allBlogPosts {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
''';

const String getBlog = r'''
  query getBlog($blogId: String!) {
    blogPost(blogId: $blogId) {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
''';

const String createBlogPost = r'''
  mutation createBlogPost($title: String!, $subTitle: String!, $body: String!) {
  createBlog(title: $title, subTitle: $subTitle, body: $body) {
    success
    blogPost {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
}
''';

const String updateBlogPost = r'''
  mutation updateBlogPost($blogId: String!, $title: String!, $subTitle: String!, $body: String!) {
    updateBlog(blogId: $blogId, title: $title, subTitle: $subTitle, body: $body) {
      success
      blogPost {
        id
        title
        subTitle
        body
        dateCreated
      }
    }
  }
''';

const String deleteBlogPost = r'''
  mutation deleteBlogPost($blogId: String!) {
    deleteBlog(blogId: $blogId) {
      success
    }
  }
''';
