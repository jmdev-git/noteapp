const Note = require('../models/Note');

exports.createNote = async (req, res) => {
  try {
    const note = new Note(req.body);
    await note.save();
    await note.populate('category');
    res.status(201).json(note);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.getNotes = async (req, res) => {
  try {
    const notes = await Note.find().populate('category');
    res.status(200).json(notes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getNoteById = async (req, res) => {
  try {
    const note = await Note.findById(req.params.id).populate('category');
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.status(200).json(note);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.status(200).json(note);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

exports.deleteNote = async (req, res) => {
  try {
    const note = await Note.findByIdAndDelete(req.params.id);
    if (!note) return res.status(404).json({ error: 'Note not found' });
    res.status(200).json({ message: 'Note deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
