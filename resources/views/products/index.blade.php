<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Product</title>
  <style>
    /* Global Styles */
    @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;800&display=swap');

    body {
      font-family: 'Nunito', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }

    /* Header Styles */
    header {
      background-image: linear-gradient(to right, #667eea, #764ba2);
      color: #fff;
      padding: 1.5rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    h1 {
      margin: 0;
      font-size: 2.5rem;
      font-weight: 800;
    }
    .auth-buttons {
  display: flex;
  gap: 1rem; /* Space between the buttons */
}.logout-button {
  /* Use the same styles as the other buttons */
  display: inline-block;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  color: #fff;
  text-decoration: none;
  font-weight: 600;
  background-image: linear-gradient(to right, #ff6b6b, #ffa500); /* Customize color */
  transition: background-image 0.3s ease;
  border: none;
  cursor: pointer;
}

.logout-button:hover {
  background-image: linear-gradient(to right, #5d5fea, #7a2ba2); /* Hover effect */
}

.logout-form {
  display: inline-block;
  margin-left: 1rem; /* Space between other buttons */
}


.register-button, .login-button, .logout-button {
  /* Shared button styling */
  display: inline-block;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  color: #fff;
  text-decoration: none;
  font-weight: 600;
  transition: background-image 0.3s ease;
}

.register-button {
  background-image: linear-gradient(to right, #6a5acd, #8a2be2); /* Customize color */
}

.login-button {
  background-image: linear-gradient(to right, #ff6b6b, #ffa500); /* Customize color */
}


.register-button:hover {
  background-image: linear-gradient(to right, #5d5fea, #7a2ba2);
}


.login-button:hover {
  background-image: linear-gradient(to right, #ff5252, #ff9100);
}

    /* Main Content Styles */
    main {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 2rem auto;
      padding: 1rem;
    }

    .message {
      background-color: #d4edda;
      color: #155724;
      padding: 1rem;
      margin-bottom: 1rem;
      border-radius: 4px;
    }

    .button {
      display: inline-block;
      background-image: linear-gradient(to right, #667eea, #764ba2);
      color: #fff;
      text-decoration: none;
      padding: 0.75rem 1.5rem;
      border-radius: 4px;
      transition: background-image 0.3s ease;
      font-weight: 600;
    }

    .button:hover {
      background-image: linear-gradient(to right, #5d6fea, #6a419a);
    }

    table {
      width: 100%;
      max-width: 1200px;
      border-collapse: collapse;
      background-color: #fff;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      border-radius: 4px;
    }

    th, td {
      padding: 1rem;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    th {
      background-color: #f5f5f5;
      font-weight: 600;
    }

    /* Responsive Styles */
    @media (max-width: 767px) {
      header {
        padding: 1rem;
      }

      h1 {
        font-size: 2rem;
      }

      main {
        margin: 1rem auto;
        padding: 0.5rem;
      }

      table {
        font-size: 0.9rem;
      }
    }
  </style>
</head>
<body>
<header>
<h1>Product</h1>
        <div class="auth-buttons">
            @guest
                <a class="register-button" href="{{ route('register') }}">Register</a>
                <a class="login-button" href="{{ route('login') }}">Login</a>
            @else
                <span class="welcome-message">Welcome, {{ Auth::user()->name }}!</span>
                <form method="POST" action="{{ route('logout') }}" class="logout-form">
                    @csrf
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            @endguest
        </div>
</header>

  <main>
  
    @if(session()->has('success'))
      <div class="message">
        {{ session('success') }}
      </div>
    @endif

    <div>
      <a class="button" href="{{ route('product.create') }}">Create a Product</a>
    </div>

    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Qty</th>
          <th>Price</th>
          <th>Description</th>
          <th>Edit</th>
          <th>Delete</th>
        </tr>
      </thead>
      <tbody>
        @foreach($products as $product)
          <tr>
            <td>{{ $product->id }}</td>
            <td>{{ $product->name }}</td>
            <td>{{ $product->qty }}</td>
            <td>{{ $product->price }}</td>
            <td>{{ $product->description }}</td>
            <td>
              <a class="button" href="{{ route('product.edit', ['product' => $product]) }}">Edit</a>
            </td>
            <td>
              <form method="post" action="{{ route('product.destroy', ['product' => $product]) }}">
                @csrf
                @method('delete')
                <input class="button" type="submit" value="Delete" />
              </form>
            </td>
          </tr>
        @endforeach
      </tbody>
    </table>
  </main>
</body>
</html>