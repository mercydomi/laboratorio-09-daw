<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Registro de contactos | JSP</title><link rel="stylesheet" href="estilos.css">
</head>
<body><main class="page"><section class="card" aria-labelledby="titulo">
  <span class="eyebrow">Laboratorio semana 09 · JSP</span><h1 id="titulo">Registro de contactos</h1>
  <p class="lead">Complete los datos para agregar un contacto a la sesión actual.</p>
  <form action="registro.jsp" method="post" novalidate>
    <label for="nombre">Nombre completo</label><input id="nombre" name="nombre" type="text" required minlength="2" maxlength="120" autocomplete="name" placeholder="Ej.: Ana Torres">
    <label for="correo">Correo electrónico</label><input id="correo" name="correo" type="email" required maxlength="254" autocomplete="email" placeholder="ana@ejemplo.com">
    <button type="submit">Registrar contacto</button>
  </form>
</section></main></body></html>
