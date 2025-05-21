🌤️ Flutter Weather App

A cross-platform Flutter application (Web & Mobile) to search and track weather forecasts for cities or countries using the [WeatherAPI](https://www.weatherapi.com/). It supports real-time weather, 4-day forecasts, and optional email subscriptions for daily weather updates.

### 📱 Mobile UI

Design mobile user interfaces (UI) using **UXPilot**, then export to **Figma** for refinement and design collaboration.

---

#### 🛠️ Creating UI in UXPilot
Open the [UXPilot Dashboard](https://uxpilot.ai/s/5a61962085bcd6f8b61711330007a730).

![CleanShot 2025-05-21 at 11 27 22@2x](https://github.com/user-attachments/assets/3a81201a-825f-494e-8e5c-9d90ade1d7be)

#### 🔁 Convert to Figma
Open my [Figma Dashboard](https://www.figma.com/design/GaAos6UwFgpEHDTRPQBTmB/UI-APP?node-id=332-61) design.

![Group 3](https://github.com/user-attachments/assets/39659245-5335-4ffd-81a2-36cf1f52aad2)
![Group 2](https://github.com/user-attachments/assets/cb20b362-24fd-46c6-833f-a877736f113e)

## ✨ Features

- 🔍 **Search Weather by Location**  
  - Search for any **city or country** to view current weather.
  
- 🌡️ **Display Today's Weather**  
  - Shows **temperature**, **humidity**, **wind speed**, and more.

- 📆 **Forecast Feature**  
  - Displays **4-day forecast**, with **"load more"** to see further days.

- 🕒 **Temporary History**  
  - Weather data is **temporarily saved** for each day using `shared_preferences`.  
  - Users can **re-display** weather info for cities searched during the same day.

- 📧 **Email Subscription**  
  - Users can **subscribe/unsubscribe** to receive daily weather updates via email.  
  - **Email confirmation** is required to activate the subscription.  

---

## 🚀 Technologies & Packages Used

### 🧩 Main Technologies

- **Flutter** – For cross-platform development
- **BLoC** – State management using `flutter_bloc`
- **Shared Preferences** – To store weather history locally
- **SMTP (mailer)** – For email communication
- **WeatherAPI** – To fetch weather data: [https://www.weatherapi.com/](https://www.weatherapi.com/)


