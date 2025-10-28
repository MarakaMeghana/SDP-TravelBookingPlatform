import { useNavigate } from "react-router-dom";
import "./App.css"; // 👈 using App.css instead of Portal.css

function App() {
  const openAdmin = () => window.open("http://localhost:5174", "_blank");
  const openCustomer = () => window.open("http://localhost:5175", "_blank");

  return (
    <div className="portal-container">
      <h1>🌍 Travel Booking Portal</h1>
      <p>Select your role to continue:</p>
      <div className="button-container">
        <button onClick={openCustomer}>Customer</button>
        <button onClick={openAdmin}>Admin</button>
      </div>
    </div>
  );
}

export default App;
