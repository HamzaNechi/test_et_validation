import express from 'express'
import { body } from 'express-validator'
import {
    addReport,
    addMood,
    getReport,
    deleteReport,
    editMood,
    getAll,
    getReportByTitle,
} from '../controllers/report-controller.js'
const router = express.Router()

router.route('/addReport').post(addReport)
router.route('/addMood').post(addMood)
router.route('/getReport/:id').get(getReport)
router.route('/').get(getAll)
router.route('/deleteReport/:id').delete(deleteReport)
router.route('/editMood').post(editMood)
router.route('/filterrport/:mood').get(getReportByTitle)

export default router