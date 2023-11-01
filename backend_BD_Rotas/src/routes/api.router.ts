import express, { Application, Request, Response, NextFunction } from "express";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

import {
  getChamados,
  getChamadoById,
  getChamadosByUser,
  getChamadoByIdAndamento,
  createChamado,
  deleteChamado,
  updateChamado,
} from "../controllers/chamados.controller";
import {
  getUsuarios,
  getUsuarioById,
  createUsuario,
  deleteUsuario,
  updateUsuario,
  loginUsuario,
  verificarToken,
} from "../controllers/usuarios.controller";

const router = express.Router();

// Chamados routes
router.get("/chamados", getChamados);
router.get("/chamados/:id", getChamadoById);
router.get("/chamados/usuario/:id", getChamadosByUser);
router.get("/chamados/andamento/:id", getChamadoByIdAndamento);
router.post("/chamados", createChamado);
router.delete("/chamados/:id", deleteChamado);
router.patch("/chamados/:id", updateChamado);

// Usuarios routes
router.get("/usuarios", getUsuarios);
router.get("/usuarios/:id", getUsuarioById);
router.post("/usuarios", createUsuario);
router.delete("/usuarios/:id", deleteUsuario);
router.patch("/usuarios/:id", updateUsuario);
router.post("/usuarios/login", loginUsuario);
router.post("/token", verificarToken) 

export default router;
