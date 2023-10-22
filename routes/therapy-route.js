import express from 'express';
import { body} from 'express-validator';
import multer from 'multer';

import { getAll, addOnce, getOnce,
 patchOnce, deleteOnce, updateT ,getTherapyByTitle, getDash} from '../controllers/therapy-controller.js';
import multerConfig from '../middelwares/multer-config.js';

const router = express.Router();

router
.route('/')
.get(getAll);


router
.route('/limit')
.get(getDash);



router.route('/add/:idUser').post (multerConfig,
    addOnce);

router
.route('/:idUser')
.get(getOnce)
.patch(patchOnce)
  router.route('/deleteOnce/:id').post(deleteOnce)
  router.route("/updateTherapy").put(updateT);


router.route('/deleteOnce/:id').delete(deleteOnce)
router.route('/updateTherapy/:id').post(
                                        multerConfig,
                                        patchOnce)
router.route('/filtertherapy/:titre').get(getTherapyByTitle)

export default router;


