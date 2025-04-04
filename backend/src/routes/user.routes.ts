import { Router } from 'express';
import { UserController } from '../controllers/user.controller';
import { authMiddleware } from '../middlewares/auth';

const router = Router();
const userController = new UserController();

// Public routes
router.post('/register', userController.register);
router.post('/login', userController.login);

// Protected routes
router.use(authMiddleware);
router.get('/me', userController.getProfile);
router.put('/me', userController.updateProfile);
router.delete('/me', userController.deleteAccount);

export default router; 