import { Router } from "express";
import { listEmails,sendRequest, acceptRequest, refuseRequest, getAll ,NumberOfReservation, cancelAppointement,VerifReservationUser,approuveAppointement,cancelReservation} from "../controllers/reservation-controller.js";

const router = Router();

router
    .route('/:id_doctor')
    .get(getAll);


router
    .route("/send")
    .post(sendRequest);

router
    .route("/accept")
    .post(acceptRequest);

router
    .route("/refuse")
    .post(refuseRequest);


router
    .route('/number')
    .get(NumberOfReservation);

router
    .route('/is_user_reserved')
    .post(VerifReservationUser);

router
    .route('/cancel_reserved')
    .post(cancelReservation);

router
    .route('/sch')
    .get(listEmails);

    router.route("/approuveR").post(approuveAppointement);
router.route("/cancelR").post(cancelAppointement);

export default router;