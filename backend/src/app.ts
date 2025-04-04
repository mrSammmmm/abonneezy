import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { errorHandler } from './middlewares/errorHandler';
import { notFoundHandler } from './middlewares/notFoundHandler';
import routes from './routes';
import logger from './utils/logger';

const app = express();

// Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(helmet());
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));

// Routes
app.use('/api/v1', routes);

// Error handling
app.use(notFoundHandler);
app.use(errorHandler);

export default app; 