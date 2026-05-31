const { useState } = React;

function ServiceCard({ label, path, onClick, active }) {
  return React.createElement(
    'button',
    {
      className: `card ${active ? 'card-active' : ''}`,
      onClick: () => onClick(path),
      type: 'button',
    },
    React.createElement('div', { className: 'card-title' }, label),
    React.createElement('div', { className: 'card-subtitle' }, `GET ${path}`)
  );
}

function App() {
  const [loading, setLoading] = useState(false);
  const [payload, setPayload] = useState(null);
  const [error, setError] = useState(null);
  const [selected, setSelected] = useState(null);

  async function fetchService(path) {
    setLoading(true);
    setError(null);
    setPayload(null);
    setSelected(path);

    try {
      const response = await fetch(path);
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      const data = await response.json();
      setPayload(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  return React.createElement(
    'div',
    { className: 'page' },
    React.createElement(
      'header',
      null,
      React.createElement('h1', null, 'EKS Portal'),
      React.createElement(
        'p',
        null,
        'A unified UI for the user and order API endpoints served by the same Python application.'
      )
    ),
    React.createElement(
      'section',
      { className: 'links' },
      React.createElement(ServiceCard, {
        label: 'User Service',
        path: '/user',
        onClick: fetchService,
        active: selected === '/user',
      }),
      React.createElement(ServiceCard, {
        label: 'Order Service',
        path: '/order',
        onClick: fetchService,
        active: selected === '/order',
      })
    ),
    React.createElement(
      'section',
      { className: 'response-card' },
      React.createElement('h2', null, 'Service response'),
      React.createElement(
        'pre',
        null,
        loading ? 'Loading...' : error ? `Error: ${error}` : payload ? JSON.stringify(payload, null, 2) : 'Choose a service to see its response.'
      )
    ),
    React.createElement(
      'section',
      { className: 'notes' },
      React.createElement(
        'p',
        null,
        'This UI is rendered using React and communicates with the single backend container at /user and /order.'
      ),
      React.createElement(
        'p',
        null,
        'If the app is deployed behind an ingress, use the ALB hostname to access it from your browser.'
      )
    )
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(React.createElement(App));
