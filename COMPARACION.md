# Comparación: PHP y JSP

Esta comparación fue elaborada y revisada por el equipo de trabajo como parte del laboratorio. Se contó con apoyo técnico puntual de Codex para contrastar conceptos y mejorar la redacción, manteniendo el análisis, aprendizaje y validación final bajo responsabilidad de los estudiantes.

| Aspecto | PHP | JSP / Java |
|---|---|---|
| Tecnología y lenguaje | PHP ejecutado en el servidor. | JSP se traduce a un servlet Java. |
| Ciclo de vida | El intérprete procesa cada solicitud; el servidor puede reutilizar procesos. | El contenedor traduce y compila la JSP la primera vez y luego atiende mediante el servlet generado. |
| Servidor utilizado | Apache HTTP Server con el módulo/configuración PHP de XAMPP. | Apache Tomcat como contenedor web/servlets. |
| Rendimiento | Depende de la versión, configuración, carga y código; es adecuado para muchas aplicaciones web. | Depende de JVM, Tomcat, carga y código; la compilación previa de JSP evita recompilar en cada solicitud. |
| Despliegue | Se copian archivos al directorio público configurado por Apache. | Se despliega la carpeta o un WAR en `webapps` de Tomcat. |
| Solicitudes HTTP | Variables superglobales como `$_POST` y `$_SERVER`. | Objetos `request` y `response` del contenedor. |
| Sesiones | `session_start()` y `$_SESSION`. | `HttpSession`, disponible como `session` en JSP. |
| Validación de formularios | Validación en PHP y HTML5 en el navegador. | Validación Java/JSP y HTML5 en el navegador. |
| Seguridad | Requiere validar entradas y escapar salida, por ejemplo con `htmlspecialchars`. | Requiere validar entradas y escapar salida; JSTL o una función de escape ayudan. |
| Manejo de errores | Códigos HTTP, excepciones y registro de errores del servidor. | Códigos HTTP, excepciones, logs del contenedor y páginas de error configurables. |
| Ecosistema y madurez | Amplio ecosistema web y gran presencia en hosting compartido. | Ecosistema Java maduro, común en aplicaciones empresariales. |
| Facilidad de desarrollo | Inicio rápido para aplicaciones pequeñas y medianas. | Requiere conocer Java y el ciclo del contenedor, pero aporta herramientas del ecosistema Java. |

La elección depende del contexto del proyecto, equipo, infraestructura y requisitos no funcionales; esta práctica compara las dos alternativas con el mismo caso de uso. El contenido fue revisado por los integrantes antes de la entrega.
