import { Request, Response, NextFunction } from "express";
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { unsubscribe } from "diagnostics_channel";

const prisma = new PrismaClient();

export const getUsuarios = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const usuarios = await prisma.usuario.findMany({
      // a linha abaixo inclui a tabela chamado para o usuário
      // include: { chamados: true }
    });
    res.json({ usuarios });
    // res.json({ usuarios, chamados })
  } catch (error) {
    next(error);
  }
};

export const getUsuarioById = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const { id } = req.params;
    const usuario = await prisma.usuario.findUnique({
      where: {
        id: Number(id),
      },
    });
    if (!usuario) {
      return res.status(404).json({ message: "Usuário não encontrado!" });
    }
    res.json(usuario);
  } catch (error) {
    next(error);
  }
};

export const createUsuario = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const senhaEncryptada = await bcrypt.hash(req.body.senhaUsuario, 10);
    const usuario = await prisma.usuario.create({
      data: {
        nomeUsuario: req.body.nomeUsuario,
        emailUsuario: req.body.emailUsuario,
        telefoneUsuario: req.body.telefoneUsuario,
        senhaUsuario: senhaEncryptada,
        nivelAcesso: req.body.nivelAcesso,
      },
    });
    res.status(201).json(usuario);
  } catch (error) {
    next(error);
  }
};

export const deleteUsuario = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const { id } = req.params;
    const usuario = await prisma.usuario.findUnique({
      where: {
        id: Number(id),
      },
    });
    if (!usuario) {
      return res.status(404).json({ message: "Usuário não encontrado!" });
    }
    const deletedUser = await prisma.usuario.delete({
      where: {
        id: Number(id),
      },
    });
    res.status(200).json(deletedUser);
  } catch (error) {
    next(error);
  }
};
export const updateUsuario = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const { id } = req.params;
    const updatedUsuario = await prisma.usuario.update({
      where: {
        id: Number(id),
      },
      data: req.body,
    });
    res.json(updatedUsuario);
  } catch (error) {
    next(error);
  }
};

export const verificarToken = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const token = req.body.token;
    const tokenValido = jwt.verify(token ?? "", process.env.JWT_PASS ?? "");
    if (tokenValido) {
      res.status(202).json({ msg: "Token válido", tokenValido });
    }
    next();
  } catch (error) {
    next(error);
  }
};


export const loginUsuario = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  try {
    const usuario = await prisma.usuario.findUnique({
      where: {
        emailUsuario: req.body.emailUsuario,
      },
    });
    if (!usuario) {
      res.status(404).json({ msg: "Usuário não encontrado" });
    }
    const senha = req.body.senhaUsuario;
    const usuarioSenha = usuario?.senhaUsuario;
    const verificarSenha = await bcrypt.compareSync(senha, usuarioSenha ?? "");
    if (verificarSenha == false) {
      res.status(401).json({ msg: "Senha incorreta" });
    }
    const token = jwt.sign(
      {
        usuario: usuario,
      },
      process.env.JWT_PASS ?? "",
      {
        expiresIn: "8h",
      },
    );
    res.status(202).json({
      msg: "Usuário logado com sucesso",
      usuario: usuario,
      token: token,
    });
  } catch (error) {
    next(error);
  }
};