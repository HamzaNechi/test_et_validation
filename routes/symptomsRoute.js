import express from "express";
import { body } from 'express-validator';
import multerConfigProfile from '../middelwares/multer-config-Profile.js';
import multerConfig from '../middelwares/multer-config.js';


import {addSymptom} from "../controllers/symptomsController.js";
import {getSymptomsByUserId} from "../controllers/symptomsController.js";

const router = express.Router();
//import upload from "../middlewares/uploads"


router.route("/add").post(addSymptom);
router.route("/getbyuser/:idUser").get(getSymptomsByUserId);




export default router;