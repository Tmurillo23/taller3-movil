




\# Matriz mínima de pruebas - Inventario RC



\## Información general



\*\*Nombre de la app:\*\* Inventario  

\*\*Tipo de app:\*\* App de inventario con persistencia local y sincronización remota  

\*\*Plataforma evaluada:\*\* Web  

\*\*Versión evaluada:\*\* 1.0.0+1  

\*\*Fecha de prueba: 5/05/2026\*\*  

\*\*Equipo evaluador: Sebastian Tamayo, Tatiana Murillo Ana Maria\*\*  



\---



\## Objetivo de la matriz



Esta matriz permite validar si la app cumple condiciones mínimas de calidad antes de considerarse una versión candidata a entrega.



No se busca demostrar que la app es perfecta.  

Se busca evidenciar:



\- Qué se probó.

\- Qué funcionó.

\- Qué falló.

\- Qué riesgos quedan abiertos.

\- Si la app puede o no considerarse Release Candidate.



\---



\## Estados posibles



| Estado | Significado |

|---|---|

| Pendiente | El caso todavía no se ha ejecutado |

| Aprobado | El resultado obtenido coincide con el resultado esperado |

| Falló | El resultado obtenido no coincide con el resultado esperado |

| No aplica | El caso no aplica para esta app o plataforma |



\---



\## Matriz de pruebas



| ID | Categoría | Escenario | Pasos | Resultado esperado | Estado | Evidencia / Observación |

|---|---|---|---|---|---|---|

| CP-01 | Inicio | Abrir la app | Ejecutar la app en web o Android | La app abre sin pantalla blanca ni crash | Pendiente | |

| CP-02 | Build | Verificar versión | Revisar `pubspec.yaml` | La app tiene versión definida, por ejemplo `1.0.0+1` | Pendiente | |

| CP-03 | Datos | Cargar productos locales | Abrir la pantalla principal | La app muestra productos existentes o estado vacío | Pendiente | |

| CP-04 | UI State | Loading inicial | Abrir la app o simular carga lenta | Se muestra un indicador de carga y la app no parece congelada | Pendiente | |

| CP-05 | UI State | Lista vacía | Ejecutar la app sin productos registrados | Se muestra un mensaje claro de estado vacío | Pendiente | |

| CP-06 | Funcionalidad | Crear producto válido | Presionar “Nuevo producto”, ingresar título y descripción, guardar | El producto aparece en la lista | Pendiente | |

| CP-07 | Validación | Crear producto sin título | Abrir formulario y guardar sin escribir título | La app muestra validación y no guarda el producto | Pendiente | |

| CP-08 | UI extrema | Crear producto con texto largo | Usar el menú QA: “crear texto largo” | La tarjeta no genera overflow ni rompe el diseño | Pendiente | |

| CP-09 | Funcionalidad | Eliminar producto | Eliminar un producto al darle clic al  botón eliminar | El producto se elimina de la vista | Pendiente | 

| CP-10 | Funcionalidad | Editar producto | Editar un producto al darle clic al botón editar | Debe abrise la vista con el formulario para editar los valores correspondientes | Pendiente | 

| CP-11 | Sincronización | Ver estado sincronizado | Crear una producto con conexión normal | La producto queda como “Sincronizada” si Firebase responde correctamente | Pendiente | |

| CP-12 | Sincronización | Error de red | Usar el menú QA: “simular error de red” | La app no crashea y la producto queda como “Sincronización pendiente” | Pendiente | |

| CP-13 | Permisos | Error permission-denied | Usar el menú QA: “simular permission-denied” | La app no crashea, registra el error y deja la producto pendiente | Pendiente | |

| CP-14 | Error inesperado | Error remoto inesperado | Usar el menú QA: “simular error inesperado” | La app no se rompe y registra el error en logs | Pendiente | |

| CP-15 | Error de UI | Error desde acción de usuario | Usar el menú QA: “simular error de UI” | La app muestra mensaje controlado y registra el error técnico | Pendiente | |

| CP-16 | Sincronización | Sincronizar pendientes | Presionar “Sincronizar pendientes” | La app intenta reenviar productos pendientes a Firebase | Pendiente | |

| CP-17 | Remoto | Actualizar desde Firebase | Presionar “Actualizar desde Firebase” | La app intenta traer datos remotos sin romper la UI | Pendiente | |

| CP-18 | Logs | Revisar logs en debug | Ejecutar la app con `flutter run` y probar acciones QA | La terminal muestra logs de info, warning o error según el caso | Pendiente | |

| CP-19 | Usuario | Mensajes amigables | Provocar un error simulado | El usuario ve un mensaje entendible, no un stacktrace | Pendiente | |

| CP-20 | Release Web | Generar build web | Ejecutar `flutter build web --release` | Se genera la carpeta `build/web/` | Pendiente | |







\## Resumen de resultados



| Resultado | Cantidad |

|---|---:|

| Casos aprobados | |

| Casos fallidos |23| 

| Casos pendientes | |

| Casos no aplica | |



\---



\## Observaciones generales


Falta el MVP