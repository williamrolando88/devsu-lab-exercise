# Como crear esta aplicación

## Crear Rails App

- Crear nueva rails app
```
rails new devsu-lab-exercise -d postgresql --css tailwind
```

- Mostrar carpetas del proyecto

- Configurar la base de datos en el archivo config/database.yml

- Correr comando y mostrar resultado
```
rails db:create
```

- Correr el servidor
```
bin/dev
```
|| 
```
rails s && rails tailwindcss:watch
```

- Hacer commit "Project initial setup"

## Crear modelos

- Crear el primer scaffold y mostrar archivos
```
rails g scaffold author first_name:string last_name:string
```

- Crear segundo scaffold
```
rails g scaffold book name:string pages:integer readed_pages:integer author:references
```

- Run migrations
```
rails db:migrate
```

- Mostrar db/schema.rb

- Mostrar relacion en books

- Agregar relacion en authors
```
has_many :books, dependent: :destroy
```

- Hacer commit "Add author and books scaffolds"

## Crear pantalla inicial

- Crear pantalla inicial
```
rails g controller bookshelf index
```

- Agregar pagina de inicio
```
root 'bookshelf#index'
```

- Modificar views/layouts/application.html.erb
```
<!DOCTYPE html>
<html>
  <head>
    <title>Devsu Lab</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body class='flex flex-col min-h-screen'>
    <header class="bg-blue-950 p-5">
      <%= link_to 'Devsu Lab', root_path, class:'text-white text-2xl font-semibold' %>
    </header>

    <section class='flex grow'>
      <nav class='bg-stone-600 p-6'>
        <p class='text-white text-xl font-semibold mb-3'>
          List books:
        </p>

        <ul class='text-gray-200 leading-5 flex flex-col gap-2'>
          <li>
            <%= link_to 'By Author', authors_path %>
          </li>
          <li>
            <%= link_to 'By Book', books_path %>
          </li>
        </ul>
      </nav>

      <main class="container mx-auto mt-28 px-5 flex">
        <%= yield %>
      </main>
    </section>

  </body>
</html>
```

- Modificar views/bookshelf/index.html.erb
```
<div>
  <h1 class="font-bold text-4xl">Welcome to your new bookshelf</h1>
  <p>Select a category at the left side to start</p>
</div>
```
- Hacer commit 'Add root page'

### Problemas presentes


- Revisar las cosas que estan mal:
  - Se puede crear autores vacios
  - Se puede crear libros vacios
  - Se debe especificar el ID del autor y no se conoce el nombre
  - Se puede borrar elementos sin una confirmacion

## Agregar validaciones

- Agregar validaciones al modelo `Author`
```
validates :first_name, :last_name, presence: true
```

- Agregar validaciones al modelo `Book`
```
validates :name, :pages, presence: true
validates :pages, numericality: { greater_than: 0 }
validates :name, uniqueness: true
validates :readed_pages, allow_blank: true, numericality: { greater_than_or_equal_to: 0 }
```

- Hacer commit 'Add author and book validation'

## Mostrar el autor al crear un libro

- Crear nuevo author

- Mostrar el ultimo error, que no se sabe que autor estamos seleccionando

- Modificar el field author_id en views/books/_form.html.erb
```
<%= form.collection_select :author_id, Author.all, :id, :last_name,  class: "block shadow rounded-md border border-gray-200 outline-none px-3 py-2 mt-2 w-full" %>
```

- Crear el metodo full_name en el modelo `Author`
```
def full_name
  "#{first_name} #{last_name}"    
end
```

- Arreglar el estilo del select field

- Add commit 'Update book creation action'

## Agregar confirmación de borrado

- Agregar delete confirmation view/authors/show.html.erb
```
<%= link_to 'Delete this author', @author, data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' }, class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

- Agregar delete confirmation view/books/show.html.erb
```
<%= link_to 'Delete this book', @book, data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' }, class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
```

- Hacer commit 'Add delete confirmation'

## Mostrar status de lectura como porcentaje

- Cambiar como se muestra readed_pages, ponerlo como status, mostrar el error que salta al intentar dividir

- Crear el method status en el modelo `Book`
```
def status
  return 0 unless readed_pages

  percentage = readed_pages.fdiv(pages) * 100
  percentage.round(2)
end
```

- Agregar el metodo "status" en views/book/_book.html.erb
```
<p class="my-5">
  <strong class="block font-medium mb-1">Status:</strong>
  <%= book.status %>
</p>
```

- Mostrar el nombre del author en lugar de su ID

- Hacer commit "Show read status"

## Mostrar libros por autor

- Borrar valores con errores en author y books

- Ultimo paso, mostrar los libros en el detalle de cada author

- Modificar views/authors/show.html.erb
```
<% @author.books.each do |book| %>
  <%= render 'books/book', book: book  %>
<% end %>
```

- Esconder el nombre del autor desde la vista de autores, modificar views/books/_book.html.erb
```
<% if controller_name == 'books' %>
  <p class="my-5">
    <strong class="block font-medium mb-1">Author:</strong>
    <%= book.author.full_name %>
  </p>
<% end %>
```

- Estilizado final, agregar tailwind classes a views/books/_book.html.erb
```
<div id="<%= dom_id book %>" class='border shadow rounded-lg px-4 mt-4'>
  <div class='flex justify-between'>
    <p class="my-5 text-xl">
      <strong class="block font-medium mb-1">Book name:</strong>
      <%= book.name %>
    </p>

    <% if controller_name == 'books' %>
      <p class="my-5">
        <strong class="block font-medium mb-1">Author:</strong>
        <%= book.author.full_name %>
      </p>
    <% end %>
  </div>


  <div class='flex justify-between'>
    <p class="my-5">
      <strong class="block font-medium mb-1">Pages:</strong>
      <%= book.pages %>
    </p>
  
    <p class="my-5">
      <strong class="block font-medium mb-1">Status</strong>
      <%= book.status %> %
    </p>
  </div>


  <% if action_name != "show" %>
    <%= link_to "Show this book", book, class: "rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>
    <%= link_to 'Edit this book', edit_book_path(book), class: "rounded-lg py-3 ml-2 px-5 bg-gray-100 inline-block font-medium" %>
    <hr class="mt-6">
  <% end %>
</div>
```

- Add commit 'Show books by author'
