import report from '../models/report.js'
import user from '../models/user.js'

export async function addReport(req, res) {
    const verifReport = await report.findOne({ date: req.body.date })
    if (verifReport) {
        console.log('report already exists')
        res.status(403).send({ message: 'Report already exists !' })
    } else {
        user.findOne({ _id: req.query.idUser })

        const newReport = new report()

        //newReport.date = req.body.date;
        newReport.mood = req.body.mood
        //newReport.depressedMood = req.body.depressedMood;
        //newReport.elevatedMood = req.body.elevatedMood;
        //newReport.irritabilityMood = req.body.irritabilityMood;

        //newReport.symptoms = req.body.symptoms;
        //newReport.user = req.body.user;

        newReport.save()

        console.log('user', newReport.user)
        res.status(201).send({
            message: 'Success : You Made Your Report Of Today',
            report: newReport,
        })
    }
}

export async function addMood(req, res) {
    const verifReport = await report.findOne({
        date: req.body.date,
        user: req.body.user,
    })
    if (verifReport) {
        console.log('report already exists')
        res.status(403).send({
            message: 'Report already exists !',
            verifReport,
            statusCode: res.statusCode,
        })
    } else {
        const newReport = new report()
        newReport.date = req.body.date
        newReport.mood = req.body.mood
        newReport.user = req.body.user
        newReport.depressedMood = 0
        newReport.elevatedMood = 0
        newReport.irritabilityMood = 0

        newReport.save()

        console.log('mood', newReport)
        res.status(200).send({
            message: 'Success : You Made Your Mood Of Today',
            newReport,
            statusCode: res.statusCode,
            _id: newReport._id,
        })
    }
}

export async function editMood(req, res) {
    const last = await report.findOne().sort({ _id: -1 });
    console.log("laseeeeeeee", last);
    if (!last) {
        // handle the scenario where there are no report entries yet
        return res.status(400).send({
            message: 'Error : There are no report entries yet',
            statusCode: res.statusCode,
        });
    }
    const editedMood = await report.findOneAndUpdate(
        { _id: last._id },
        {
            depressedMood: req.body.depressedMood,
            elevatedMood: req.body.elevatedMood,
            irritabilityMood: req.body.irritabilityMood,
        },
        { new: true }
    )

    res.status(200).send({
        message: 'Success : You Made Your Symptoms Of Today Too ',
        editedMood,
        statusCode: res.statusCode,
    })
}


export async function getReport(req, res) {
    const Report = await report.find({ user: req.params.id })
    if (Report) {
        res.status(200).send(Report)
        console.log(Report);
    } else {
        res.status(403).send({ message: 'fail' })
    }
}

export function getAll(req, res) {
    report
        .find({})
        .then((docs) => {
            res.status(200).json(docs)
        })
        .catch((err) => {
            res.status(500).json({ error: err })
        })
}

export async function getReportByTitle(req, res) {
    const mood = req.params.mood.trim()
    console.log(`mood: ${mood}`)
    const regex = new RegExp(mood, 'i')
    const therapies = await report.find({ mood: regex })
    console.log(`therapies: ${therapies}`)
    if (therapies.length > 0) {
        res.status(200).json(therapies)
    } else {
        res.status(404).send({
            message: `No therapies found with title containing '${mood}'`,
        })
    }
}

export async function deleteReport(req, res) {
    const Report = await report.findOneAndDelete({ _id: req.params.id })
    res.status(200).send({ message: 'Success: Report Deleted' })
}

export async function editReport(req, res) {
    const editedReport = await report.findOneAndUpdate(
        { _id: req.params.id },
        {
            date: req.body.date,
            mood: req.body.mood,
            depressedMood: req.body.depressedMood,
            elevatedMood: req.body.elevatedMood,
            irritabilityMood: req.body.irritabilityMood,
            symptoms: req.body.symptoms,
        }
    )

    res.status(201).send({
        message: 'Success : You Edit Your Report ',
        editedReport,
    })
}