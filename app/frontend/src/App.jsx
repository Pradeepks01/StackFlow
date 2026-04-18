import React, { useState, useEffect } from 'react';
import axios from 'axios';

const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5000',
});

function App() {
    const [status, setStatus] = useState('Checking...');
    const [metrics, setMetrics] = useState(null);

    useEffect(() => {
        api.get('/health')
            .then(res => setStatus(res.data.status))
            .catch(() => setStatus('Backend Offline'));
    }, []);

    return (
        <div className="container">
            <header>
                <h1>StackFlow</h1>
                <div className={`badge ${status.toLowerCase()}`}>{status}</div>
            </header>

            <main>
                <section className="hero">
                    <h2>Enterprise DevOps Pipeline</h2>
                    <p>Full-stack observability, GitOps, and automated deployments.</p>
                </section>

                <section className="grid">
                    <div className="card">
                        <h3>Infrastructure</h3>
                        <p>AWS EKS, RDS, VPC & ALB provisioned via Terraform.</p>
                    </div>
                    <div className="card">
                        <h3>CI/CD</h3>
                        <p>GitHub Actions push images to ECR and update Helm charts.</p>
                    </div>
                    <div className="card">
                        <h3>GitOps</h3>
                        <p>Argo CD ensures state consistency across environments.</p>
                    </div>
                    <div className="card">
                        <h3>Monitoring</h3>
                        <p>Prometheus, Grafana, and ELK stack for deep insights.</p>
                    </div>
                </section>
            </main>

            <footer>
                <p>&copy; 2026 StackFlow DevOps Engine</p>
            </footer>
        </div>
    );
}

export default App;
