import  express from "express";
import { addReclamation,deleteReclamation,getReclamations ,ReponseReclamation} from "../controllers/reclamation.js";

const router = express.Router();


router
    .route('/')
    .post(addReclamation)
    .get(getReclamations);

router
    .route('/reponse')
    .post(ReponseReclamation);

router
    .route('/:recId')
    .delete(deleteReclamation);



export default router;