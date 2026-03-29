# интернет-магазин (Flutter + Django)

## 1. Запуск бэкенда (Django)

# 1. Создаем и активируем виртуальное окружение

python -m venv venv
venv\Scripts\activate

# Для Linux (Arch) / macOS:
source venv/bin/activate

# 2. Устанавливаем необходимые библиотеки
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers

# 3. Применяем миграции для создания базы данных
python manage.py makemigrations
python manage.py migrate

# 4. Создаем админа для добавления товаров
python manage.py createsuperuser

# 5. Запускаем локальный сервер
python manage.py runserver


## 2. Запуск Flutter

# 1.
flutter pub get

# 2. 
flutter run

