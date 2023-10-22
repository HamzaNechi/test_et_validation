import mongoose from 'mongoose';
const { Schema, model } = mongoose;

const ScheduleSchema = new mongoose.Schema({
    ///doctorId: { type: Schema.Types.ObjectId, ref: 'user' },
    dayOfWeek: {
      type: String,
    },
    startTime: {
      type: String,
    },
    endTime: {
      type: String,
    },
    user: {
      type: Schema.Types.ObjectId, 
      ref: 'user' 
 },
 appointement: { type: Schema.Types.ObjectId, ref: 'appointement' },
},
{
    timestamp: true
}
);
export default mongoose.model('schedule', ScheduleSchema);