import { Router } from 'express';
import { SubscriptionController } from '../controllers/subscription.controller';
import { authMiddleware } from '../middlewares/auth';

const router = Router();
const subscriptionController = new SubscriptionController();

router.use(authMiddleware);

router.post('/', subscriptionController.create);
router.get('/', subscriptionController.getAll);
router.get('/:id', subscriptionController.getOne);
router.put('/:id', subscriptionController.update);
router.delete('/:id', subscriptionController.delete);

export default router; 