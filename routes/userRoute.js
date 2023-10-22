import express from "express";
import { body } from 'express-validator';
import multerConfigProfile from '../middelwares/multer-config-Profile.js';
import multerConfig from '../middelwares/multer-config.js';

import {getPatientByIdDoctor,getAllUsers, ReservationConfirmation,login, signUp,forgotpassword ,getallusresde,editPassword,getUsersBySpeciality,changeUserPhoto, enable, verif ,getUser,loginGoogle,editLoginGoogleUser,editDoctorDetails, getPatientByPatient, getalls, getalldoctorsde, getallpatientsde, deleteOne} from "../controllers/userController.js";
const router = express.Router();
//import upload from "../middlewares/uploads"


router.route("/signup").post(multerConfigProfile, signUp);
router.route("/login").post(login);
router.route("/enable-2fa").post(enable);
router.route("/verif").post(verif);
router.route("/getAllUsers").get(getAllUsers);
router.route("/reset_password").post(forgotpassword)
router.route("/edit_password").put(editPassword)
router.route("/filterdoctor/:speciality").get(getUsersBySpeciality)
router.route("/updatePhoto/:email").post(multerConfig, changeUserPhoto);

router.route("/getUser/:id").get(getUser);
router.route("/loginGoogle").post(loginGoogle);
router.route("/editLoginGoogleUser/:email").post(editLoginGoogleUser);
router.route("/editDoctorDetails/:email").put(editDoctorDetails);

router.route("/send").post(ReservationConfirmation);
router.route("/getPatients/:id_doctor").get(getPatientByIdDoctor);
router.route('/filterPatient/:fullName').get(getPatientByPatient);

// remove this
router.route("/getalls").get(getalls);


// get
router.route("/getalldoctors").get(getalldoctorsde);

router.route("/getallpatients").get(getallpatientsde);

router.route("/getallusers2").get(getallusresde);

//delete
router.route("/deleteone/").delete(deleteOne);


export default router;