import express from "express";

const router = express.Router();
import {sendAppointement , getAppointementsDoctor , getAppointementsUser, approuveAppointement, getAppointementsDoctorApprouved ,confirmPatient , cancelAppointement} from "../controllers/appointementController.js";

router.route("/sendAppointement/:id").post(sendAppointement);
router.route("/getAppointementsUser/:id").get(getAppointementsUser);
router.route("/getAppointementsDoctor/:id").get(getAppointementsDoctor);
router.route("/getAppointementsDoctorApprouved/:id").get(getAppointementsDoctorApprouved);
router.route("/approuveAppointement").post(approuveAppointement);
router.route("/confirmPatient").post(confirmPatient);
router.route("/cancelAppointement").post(cancelAppointement);


export default router;