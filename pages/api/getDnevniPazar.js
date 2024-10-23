import sql from 'mssql';

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER, // e.g., 'localhost' or 'your_server_ip'
    database: process.env.DB_NAME,
    options: {
        encrypt: true, // Use this if you're on Azure
        trustServerCertificate: true, // Change to false if you have a valid certificate
    },
};

export default async function handler(req, res) {
    try {
        await sql.connect(config);
        const result1 = await sql.query`EXEC iw_DnevniPazar 0`;
        const result2 = await sql.query`EXEC iw_DnevniPazar 1`;
        res.status(200).json({ result1: result1.recordset, result2: result2.recordset });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database connection failed' });
    } finally {
        await sql.close();
    }
}
