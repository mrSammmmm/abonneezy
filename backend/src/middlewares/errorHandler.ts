import { Request, Response, NextFunction } from 'express';
import logger from '../utils/logger';

export class AppError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export const errorHandler = (
  err: Error | AppError,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (err instanceof AppError) {
    logger.warn(err.message);
    res.status(err.statusCode).json({
      status: 'error',
      message: err.message
    });
    return;
  }

  logger.error(err.message);
  res.status(500).json({
    status: 'error',
    message: 'Internal server error'
  });
}; 