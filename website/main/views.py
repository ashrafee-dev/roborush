from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

# Create your views here.
def home(request):
    return render(request, 'home.html')

@csrf_exempt
def order(request):
    if request.method == "POST":
        data = json.loads(request.body.decode("utf-8"))
        location = data.get("location")
        selected_items = data.get("selected_items", [])

        response = {
            "location": location,
            "selected_items": selected_items
        }
        return JsonResponse(response)
    return JsonResponse({"error": "Invalid request"}, status=400)

    