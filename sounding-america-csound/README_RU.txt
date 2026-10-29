SOUNDING AMERICA — отдельная публикация GitHub Pages

Этот комплект подготовлен для репозитория:
https://github.com/polinastolbova/sounding_america

Ожидаемый адрес сайта:
https://polinastolbova.github.io/sounding_america/

ЧТО ВНУТРИ
- index.html и src/main.js — веб-интерфейс с Csound WebAssembly;
- csd/ — 15 оригинальных композиций (Entrance, 13 основных разделов и Exit);
- vite.config.js — корректный базовый путь /sounding_america/;
- .github/workflows/deploy-pages.yml — автоматическая сборка и публикация.

КАК УСТАНОВИТЬ БЕЗ ИЗМЕНЕНИЙ ECHOFORMA
1. Откройте только репозиторий sounding_america:
   https://github.com/polinastolbova/sounding_america
2. Убедитесь, что выбрана ветка main.
3. Загрузите содержимое ЭТОГО архива в корень репозитория, сохраняя папки:
   .github/workflows/deploy-pages.yml
   csd/...
   src/...
   index.html, package.json, vite.config.js, README.md, README_RU.txt
   Не загружайте внешнюю папку sounding-america-csound целиком внутрь репозитория.
4. Сделайте Commit changes в ветку main.
5. Откройте Settings → Pages → Build and deployment → Source и выберите
   GitHub Actions.
6. Откройте Actions. Дождитесь успешного запуска “Deploy Sounding America to GitHub Pages”.
7. Откройте https://polinastolbova.github.io/sounding_america/ .

ВАЖНО
- Не меняйте репозиторий polinastolbova/echoforma.
- Не удаляйте исходные .csd.
- Первый запуск аудио может занять несколько секунд: Csound загружается в браузере.
- Для воспроизведения нажмите Play; браузер не запускает звук автоматически.
