from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import RegisterView, ProductViewSet, CartView, RemoveFromCartView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

router = DefaultRouter()
router.register(r'products', ProductViewSet)

urlpatterns = [
    path('', include(router.urls)),
    
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'), 
    
    path('cart/', CartView.as_view(), name='cart'),
    path('cart/remove/<int:item_id>/', RemoveFromCartView.as_view(), name='cart_remove'),
]