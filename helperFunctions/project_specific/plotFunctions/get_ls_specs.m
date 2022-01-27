function res = get_ls_specs(opt)

    res = struct;
    if isfield(opt, "ls")
        res.ls_c = opt.ls;
    else
        res.ls_c = "-";
    end

    if isfield(opt, "m")
        res.m_c = opt.m;
    else
        res.m_c = "none";
    end

    if isfield(opt, "m_space")
        res.m_space = opt.m_space;
    else
        res.m_space = 1;
    end

    if isfield(opt, "m_offset")
        res.m_offset = opt.m_offset;
    else
        res.m_offset = 1;
    end

end
