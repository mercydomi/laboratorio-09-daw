<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.util.regex.*" %>
<%!
  private static String escapeHtml(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#x27;");
  }
%>
<%
  response.setHeader("X-Content-Type-Options", "nosniff");
  response.setHeader("X-Frame-Options", "DENY");
  response.setHeader("Referrer-Policy", "same-origin");
  String message = ""; String messageType = "error"; int status = 200;
  List<Map<String, String>> records;
  Object saved = session.getAttribute("registros");
  if (saved instanceof List<?>) records = (List<Map<String, String>>) saved;
  else { records = new ArrayList<Map<String, String>>(); session.setAttribute("registros", records); }
  if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setHeader("Allow", "POST"); status = 405; message = "Método no permitido. Use el formulario para enviar una solicitud POST.";
  } else {
    try {
      String nombre = request.getParameter("nombre"); String correo = request.getParameter("correo");
      nombre = nombre == null ? "" : nombre.trim(); correo = correo == null ? "" : correo.trim();
      List<String> errors = new ArrayList<String>();
      if (nombre.isEmpty()) errors.add("El nombre completo es obligatorio.");
      else if (nombre.codePointCount(0, nombre.length()) < 2 || nombre.codePointCount(0, nombre.length()) > 120) errors.add("El nombre debe tener entre 2 y 120 caracteres.");
      if (correo.isEmpty()) errors.add("El correo electrónico es obligatorio.");
      else if (correo.length() > 254 || !Pattern.matches("^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$", correo)) errors.add("Ingrese un correo electrónico válido.");
      if (!errors.isEmpty()) { status = 400; message = String.join(" ", errors); }
      else { Map<String, String> item = new LinkedHashMap<String, String>(); item.put("nombre", nombre); item.put("correo", correo); records.add(item); session.setAttribute("registros", records); messageType = "success"; message = "Contacto registrado correctamente."; }
    } catch (Exception exception) { getServletContext().log("Error al registrar contacto", exception); status = 500; message = "No fue posible procesar la solicitud. Intente nuevamente."; }
  }
  response.setStatus(status);
%>
<!doctype html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Contactos registrados | JSP</title><link rel="stylesheet" href="estilos.css"></head>
<body><main class="page"><section class="card wide" aria-labelledby="titulo-registros"><span class="eyebrow">Laboratorio semana 09 · JSP</span><h1 id="titulo-registros">Registro de contactos</h1>
<p class="message <%= messageType %>" role="status"><%= escapeHtml(message) %></p><p><a class="back" href="index.jsp">← Registrar otro contacto</a></p>
<div class="table-wrap"><table><thead><tr><th>N.º</th><th>Nombre completo</th><th>Correo electrónico</th></tr></thead><tbody>
<% if (records.isEmpty()) { %><tr><td colspan="3" class="empty">Aún no hay contactos registrados en esta sesión.</td></tr><% } else { for (int i = 0; i < records.size(); i++) { Map<String,String> item = records.get(i); %>
<tr><td><%= i + 1 %></td><td><%= escapeHtml(item.get("nombre")) %></td><td><%= escapeHtml(item.get("correo")) %></td></tr><% } } %>
</tbody></table></div></section></main></body></html>
