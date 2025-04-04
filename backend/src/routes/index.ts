import { Router } from 'express';
import subscriptionRoutes from './subscription.routes';
import userRoutes from './user.routes';

const router = Router();

router.get('/', (_req, res) => {
  res.json({ message: 'Welcome to Abonneezy API' });
});

router.use('/subscriptions', subscriptionRoutes);
router.use('/users', userRoutes);

export default router; 