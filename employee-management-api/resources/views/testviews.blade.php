<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Form</title>
</head>
<body>
    <form method="POST" action="/test-submit">
        @csrf
        <label for="name">Nama:</label>
        <input type="text" id="name" name="name" required>
        <button type="submit">Submit Test</button>
    </form>
</body>
</html>