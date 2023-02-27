// SPDX-FileCopyrightText: 2018 Frank Hunleth, Mark Sebald
//
// SPDX-License-Identifier: Apache-2.0

#include "erl_nif.h"

static ERL_NIF_TERM atom_error;

static int nif_load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM info)
{
    atom_error = enif_make_atom(env, "error");

    *priv_data = NULL;
    return 0;
}

static void nif_unload(ErlNifEnv *env, void *priv_data)
{
}

static ERL_NIF_TERM nif_inspect_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary bin;

    if (!enif_inspect_binary(env, argv[0], &bin))
        return atom_error;

    return enif_make_uint(env, bin.size);
}

static ERL_NIF_TERM nif_inspect_iolist_as_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary bin;

    if (!enif_inspect_iolist_as_binary(env, argv[0], &bin))
        return atom_error;

    return enif_make_uint(env, bin.size);
}

static ERL_NIF_TERM nif_inspect_iovec(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifIOVec vec, *iovec = &vec;
    ERL_NIF_TERM tail;

    if (!enif_inspect_iovec(env, 16, argv[0], &tail, &iovec))
        return atom_error;

    return enif_make_uint(env, vec.size);
}

static ErlNifFunc nif_funcs[] =
{
    {"nif_inspect_binary", 1, nif_inspect_binary, ERL_NIF_DIRTY_JOB_IO_BOUND},
    {"nif_inspect_iolist_as_binary", 1, nif_inspect_iolist_as_binary, ERL_NIF_DIRTY_JOB_IO_BOUND},
    {"nif_inspect_iovec", 1, nif_inspect_iovec, ERL_NIF_DIRTY_JOB_IO_BOUND}
};

ERL_NIF_INIT(Elixir.IODataNIF, nif_funcs, nif_load, NULL, NULL, nif_unload)
