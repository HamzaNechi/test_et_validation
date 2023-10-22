import mongoose from 'mongoose';
const { Schema, model } = mongoose;

const AppointementSchema = new Schema({
  
    patient: { type: Schema.Types.ObjectId, ref: 'user' },
    doctor: { type: Schema.Types.ObjectId, ref: 'user' },
    user: { type: Schema.Types.ObjectId, ref: 'user' },
    date: {
        type: Date,
        default: Date.now()
    },
    time: {
        type: String,
    },
    day: {
        type: String,

    },
    upcoming:{
        type: Boolean,
    },
    canceled:{
        type: Boolean,
    },
    statuss: {
        type: String,
    }

},
    {
        timestamp: true
    }
);

export default mongoose.model('appointement', AppointementSchema);