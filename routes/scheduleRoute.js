import express from "express";

const router = express.Router();
import { addWorkingHours, getSchedule,getUserWithSchedule} from "../controllers/scheduleController.js";

router.route("/addWorkingHours/:id").post(addWorkingHours);
router.route("/getSchedule/:id").get(getSchedule);

router.route("/getUserSchedule/:_id").get(getUserWithSchedule);
export default router;