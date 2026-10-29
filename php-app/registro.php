<?php

declare(strict_types=1);

ini_set('display_errors', '0');
set_error_handler(static function (int $severity, string $message, string $file, int $line): never {
  throw new ErrorException($message, 0, $severity, $file, $line);
});
try {
  if (!session_start()) {
    throw new RuntimeException('No se pudo iniciar la sesión.');
  }
} catch (Throwable $exception) {
  error_log('Error al iniciar sesión: ' . $exception->getMessage());
  http_response_code(500);
  header('Content-Type: text/html; charset=UTF-8');
  exit('<!doctype html><html lang="es"><head><meta charset="UTF-8"><title>Error</title></head><body><p>No fue posible procesar la solicitud. Intente nuevamente.</p></body></html>');
} finally {
  restore_error_handler();
}
header('Content-Type: text/html; charset=UTF-8');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('Referrer-Policy: same-origin');

function escapeHtml(string $value): string
{
  return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function renderPage(string $message, string $messageType, array $records, int $status = 200): void
{
  http_response_code($status);
?>
  <!doctype html>
  <html lang="es">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Contactos registrados | PHP</title>
    <link rel="stylesheet" href="estilos.css">
  </head>

  <body>
    <main class="page">
      <section class="card wide" aria-labelledby="titulo-registros">
        <span class="eyebrow">Laboratorio semana 09 · PHP</span>
        <h1 id="titulo-registros">Registro de contactos</h1>
        <p class="message <?= escapeHtml($messageType) ?>" role="status"><?= escapeHtml($message) ?></p>
        <p><a class="back" href="index.html">← Registrar otro contacto</a></p>
        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>N.º</th>
                <th>Nombre completo</th>
                <th>Correo electrónico</th>
              </tr>
            </thead>
            <tbody>
              <?php if ($records === []): ?>
                <tr>
                  <td colspan="3" class="empty">Aún no hay contactos registrados en esta sesión.</td>
                </tr>
                <?php else: foreach ($records as $index => $record): ?>
                  <tr>
                    <td><?= $index + 1 ?></td>
                    <td><?= escapeHtml((string) ($record['nombre'] ?? '')) ?></td>
                    <td><?= escapeHtml((string) ($record['correo'] ?? '')) ?></td>
                  </tr>
              <?php endforeach;
              endif; ?>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </body>

  </html>
<?php
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  header('Allow: POST');
  renderPage('Método no permitido. Use el formulario para enviar una solicitud POST.', 'error', $_SESSION['registros'] ?? [], 405);
  exit;
}

try {
  $nombre = isset($_POST['nombre']) && is_string($_POST['nombre']) ? trim($_POST['nombre']) : '';
  $correo = isset($_POST['correo']) && is_string($_POST['correo']) ? trim($_POST['correo']) : '';
  $errors = [];

  if ($nombre === '') $errors[] = 'El nombre completo es obligatorio.';
  elseif (mb_strlen($nombre, 'UTF-8') < 2 || mb_strlen($nombre, 'UTF-8') > 120) $errors[] = 'El nombre debe tener entre 2 y 120 caracteres.';
  if ($correo === '') $errors[] = 'El correo electrónico es obligatorio.';
  elseif (strlen($correo) > 254 || filter_var($correo, FILTER_VALIDATE_EMAIL) === false) $errors[] = 'Ingrese un correo electrónico válido.';

  $records = isset($_SESSION['registros']) && is_array($_SESSION['registros']) ? $_SESSION['registros'] : [];
  if ($errors !== []) {
    renderPage(implode(' ', $errors), 'error', $records, 400);
    exit;
  }

  $records[] = ['nombre' => $nombre, 'correo' => $correo];
  $_SESSION['registros'] = $records;
  renderPage('Contacto registrado correctamente.', 'success', $records);
} catch (Throwable $exception) {
  error_log('Error al registrar contacto: ' . $exception->getMessage());
  renderPage('No fue posible procesar la solicitud. Intente nuevamente.', 'error', [], 500);
}
