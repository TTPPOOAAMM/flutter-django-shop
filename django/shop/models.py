from django.db import models
from django.contrib.auth.models import User

class Product(models.Model):
    """Модель товара в каталоге"""
    name = models.CharField(max_length=255, verbose_name="Название товара")
    description = models.TextField(verbose_name="Описание", blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Цена")

    image_url = models.URLField(blank=True, verbose_name="Ссылка на картинку")

    def __str__(self):
        return self.name

class Cart(models.Model):
    """Модель корзины покупок (одна корзина на одного пользователя)"""
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='cart')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Корзина пользователя: {self.user.username}"

class CartItem(models.Model):
    """Модель конкретного товара в корзине"""
    cart = models.ForeignKey(Cart, related_name='items', on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1, verbose_name="Количество")

    def __str__(self):
        return f"{self.quantity} шт. - {self.product.name}"