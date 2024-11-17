<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Edit Product</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #1a1a1a;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        h1 {
            text-align: center;
            margin-bottom: 2rem;
            color: #b366ff;
        }

        .error-list {
            background-color: #ff99ff;
            border: 1px solid #ff66ff;
            color: #1a1a1a;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
        }

        .error-list li {
            list-style-type: none;
        }

        form {
            background-color: #330066;
            padding: 2rem;
            border-radius: 8px;
            max-width: 400px;
            width: 100%;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: #d9b3ff;
        }

        input[type="text"] {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #7a7a7a;
            border-radius: 4px;
            font-size: 1rem;
            background-color: #1a1a1a;
            color: #d9b3ff;
        }

        input[type="submit"] {
            background-color: #b366ff;
            color: #1a1a1a;
            border: none;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #cc99ff;
        }

        .back-button {
            display: block;
            margin-top: 1.5rem;
            background-color: #7a7a7a;
            color: #1a1a1a;
            border: none;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #999999;
        }

        .popup {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #330066;
            color: #d9b3ff;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            z-index: 100;
            text-align: center;
        }

        .popup-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 99;
        }
    </style>
</head>
<body>
    <div>
        <h1>Edit a Product</h1>
        <div>
            @if($errors->any())
            <div class="error-list">
                <ul>
                    @foreach($errors->all() as $error)
                        <li>{{$error}}</li>
                    @endforeach
                </ul>
            </div>
            @endif
        </div>
        <form method="post" action="{{route('product.update', ['product' => $product])}}" id="product-form">
            @csrf
            @method('put')
            <div class="form-group">
                <label>Name</label>
                <input type="text" name="name" placeholder="Name" value="{{$product->name}}" required>
            </div>
            <div class="form-group">
                <label>Qty</label>
                <input type="text" name="qty" placeholder="Qty" value="{{$product->qty}}" required>
            </div>
            <div class="form-group">
                <label>Price</label>
                <input type="text" name="price" placeholder="Price" value="{{$product->price}}" required>
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description" placeholder="Description" value="{{$product->description}}" required>
            </div>
            <div class="form-group">
                <input type="submit" value="Update" id="submit-btn">
            </div>
        </form>
        <a href="../" class="back-button">Go Back</a>
    </div>

    <div class="popup-overlay" id="popup-overlay" style="display: none;"></div>
    <div class="popup" id="popup" style="display: none;">
        <h2>Please fill out all required fields.</h2>
        <button onclick="closePopup()">OK</button>
    </div>

    <script>
        const form = document.getElementById('product-form');
        const submitBtn = document.getElementById('submit-btn');
        const popupOverlay = document.getElementById('popup-overlay');
        const popup = document.getElementById('popup');

        form.addEventListener('submit', function(event) {
            event.preventDefault();

            // Check if any required fields are missing
            if (!form.name.value || !form.qty.value || !form.price.value || !form.description.value) {
                showPopup();
                return;
            }

            // Submit the form if all fields are valid
            form.submit();
        });

        function showPopup() {
            popupOverlay.style.display = 'block';
            popup.style.display = 'block';
        }

        function closePopup() {
            popupOverlay.style.display = 'none';
            popup.style.display = 'none';
        }
    </script>
</body>
</html>