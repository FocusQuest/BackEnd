import { Request, Response, NextFunction } from 'express';
import { PrismaClient, Prisma } from '@prisma/client';
const prisma = new PrismaClient();

export const getChamados = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const chamados = await prisma.chamado.findMany({
      // passando esta linha abaixo, ele puxa o usuário junto com o chamado
      include: { usuario: true }
    })
    res.json(chamados);
  } catch (error) {
    next(error);
  }
};

export const getChamadoByIdAndamento = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const chamado = await prisma.chamado.findMany({
      where: {
        idAndamento: Number(id),
      },
      include: { usuario: true, andamento: true, suporte: true, prioridade: true }
    });
    // if (chamado.length === 0) {
    //   return res.status(404).json({ message: 'Nenhum chamado encontrado pare este status de andamento!' });
    // }
    res.json(chamado);
  } catch (error) {
    next(error);
  }
};


export const getChamadoById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const chamado = await prisma.chamado.findUnique({
      where: {
        id: Number(id),
      },
      include: { usuario: true, andamento: true, suporte: true, prioridade: true }
    });
    if (!chamado) {
      return res.status(404).json({ message: 'Chamado não encontrado!' });
    }
    res.json(chamado);
  } catch (error) {
    next(error);
  }
};

export const getChamadosByUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const usuario = await prisma.usuario.findUnique({
      where: {
        id: Number(id),
      },
    })
    const chamados = await prisma.chamado.findMany({
      where: {
        idUsuario: Number(id),
      },
    });
    if (!usuario) {
      return res.status(404).json({ message: 'Usuário não encontrado!' });
    }
    res.json(chamados);
  } catch (error) {
    next(error);
  }
};
 


export const createChamado = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const createdChamado = await prisma.chamado.create({
      data: {
        nomeChamado: req.body.nomeChamado,
        descChamado: req.body.descChamado,
        idUsuario: parseInt(req.body.idUsuario),
        idLab: parseInt(req.body.idLab),
        idComputador: parseInt(req.body.idComputador),
        idCategoria: parseInt(req.body.idCategoria),
        prioridade: req.body.prioridade,
        
        
      },
    });
    res.status(201).json(createdChamado);
  } catch (error) {
    next(error);
  }
};

export const deleteChamado = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const deletedChamado = await prisma.chamado.delete({
      where: {
        id: Number(id),
      },
    });
    res.sendStatus(204).json(deletedChamado);
  } catch (error) {
    next(error);
  }
};


export const updateChamado = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;

    const data: Prisma.ChamadoUpdateInput = {
      ...req.body,
    };

    if (req.body.tratInicio === "") {
      data.tratInicio = new Date();
    } else if (req.body.tratInicio) {
      data.tratInicio = new Date(req.body.tratInicio);
    }

    if (req.body.tratFim === "") {
      data.tratFim = new Date();
    } else if (req.body.tratFim) {
      data.tratFim = new Date(req.body.tratFim);
    }

    // Se a prioridade for enviada na solicitação, adicione-a ao objeto data
    if (req.body.prioridade) {
      data.prioridade = req.body.prioridade;
    }

    if (req.body.mensagem) {
      data.mensagem = req.body.mensagem;
    }

    const updatedChamado = await prisma.chamado.update({
      where: {
        id: Number(id),
      },
      data,
    });

    

    res.json(updatedChamado);
  } catch (error) {
    next(error);
  }
};