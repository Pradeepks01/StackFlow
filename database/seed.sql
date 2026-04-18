INSERT INTO users (username, email) VALUES 
('admin', 'admin@stackflow.io'),
('devops_user', 'devops@stackflow.io')
ON CONFLICT DO NOTHING;

INSERT INTO system_logs (level, message, service) VALUES 
('INFO', 'System initialized', 'stackflow-backend'),
('INFO', 'Database seeded', 'stackflow-db');
