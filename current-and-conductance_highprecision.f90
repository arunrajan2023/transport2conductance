!Program to find the current and conductance from the electron tranmission curves.  
!Use 'gfortran' to compile if ifort fails 

!Differential is found using the formula f'(x) =  [-f(x+2h) + 8f(x+h) - 8f(x-h) + f(x-2h)] / 12h  ; O~(h^5)

!FD included..!

program new
        implicit none

        integer::unt1, unt2, unt3, unt4, unt5, sr_no, ictr, iint, done, ok, ifd, nfd, imid, jctr, kctr
        integer::idata, ndata, istart, iend, ivolt, nvolt, pctr, mctr, nlimit, true, npctr, nmctr, npos, ipos
        real(kind(1d0))::ien, enupper, enlower
        real(kind(1d0)),allocatable,dimension(:,:)::en, trans, volt
        real(kind(1d0))::integral, interval, g, f0, fn, sum_0n, sumevn, sumodd, temp                      
        real(kind(1d0))::kbT, fdplus, fdminus, vbias, temperature, kb, ienergy, den, dfd0                        
        real(kind(1d0)),allocatable,dimension(:)::dfd, dfdplus, dfdminus, occu_fn
        real(kind(1d0)),allocatable,dimension(:,:)::current
        character*50::fintrans, fouttrans, fcurrent, fg
        character*50,allocatable,dimension(:)::fdiff_g

        open(1,  file="current-and-conductance.in", action="read")
        open(2,  file="2d-trans.dat",               action="write")
        open(3,  file="2d-current.dat",             action="write")
        open(4,  file="2d-g.dat",                   action="write")
        open(5,  file="2d-diff-g.dat",              action="write")
!       open(9,  file="fd-at-Ef-n1V.dat",           action="write")
        open(11, file="plusdata.dat",               action="write")
        open(12, file="minusdata.dat",              action="write")

        unt1 = 50
        unt2 = 500 
        unt3 = 1000 
        unt4 = 1500
        unt5 = 2000 
        
        kb   = 8.6173324*1e-5          !eV/K           
        temperature= 300.0             !K
        kbT  = kb * temperature        !eV
        print*, "kbT=", real(kbT), "eV"

        read(1, *)
        read(1, *) nvolt

        read(1, *)
        read(1, *) ndata

        allocate(en(nvolt, ndata), trans(nvolt, ndata), current(nvolt, ndata), volt(nvolt, ndata), stat=done)
        if(done .ne. 0) then
                print*, "err"
                stop
        end if  !done 

        nlimit = 200                                                    !2* nlimit +1 is the no: of FD values 
        nfd    = 2.0d0 * ndata - 1                                      !Total no: of energy points (-2 to +2)                          
        allocate(dfd(nfd), dfdplus(nlimit), dfdminus(nlimit), fdiff_g(nvolt), occu_fn(ndata), stat=true)
        if(true .ne. 0) then
                print*, 'mem alloc err'
                stop
        end if  !true

        !-------------------------------------------------------------------------------------------------------------------
        read(1, *)
        do ivolt=1, nvolt
                read(1, *) sr_no, fintrans, fouttrans, fcurrent, fg, fdiff_g(ivolt)
                unt1 = unt1 + 1
                unt2 = unt2 + 1
                unt3 = unt3 + 1
                unt4 = unt4 + 1
                write(2, *)
                write(3, *)
                write(4, *)
                open(unt1, file=trim(fintrans),  action="read")
                open(unt2, file=trim(fouttrans), action="write")
                open(unt3, file=trim(fcurrent),  action="write")
                open(unt4, file=trim(fg),        action="write")
                do idata=1, ndata
                        read(unt1, *) en(ivolt, idata), volt(ivolt, idata), trans(ivolt, idata) 
                        if((real(en(ivolt, idata)) .ge. -1.5) .and. (real(en(ivolt, idata)) .le. -0.5)) then
                                if(mod(idata, 4) .eq. 0) then
                                        write(2, *) en(ivolt, idata), volt(ivolt, idata), trans(ivolt, idata)
                                end if  !if
                        end if          !if                                
                end do                  !idata

                !------------------------------------------------------------------------------------------------------ 
                                                                        			!Difference in the Fermi-Dirac distributions around 0eV 
                den    = en(ivolt, ndata) - en(ivolt, ndata-1)
                vbias  = volt(ivolt, ndata)
                pctr   = 0
                mctr   = 0
                do ifd=1, nfd
                        ienergy = (ifd - 1.0d0) * den - 2.0                                     !range -2 to 0 insteps of den 
                        fdplus  = 1.0d0 / (exp((ienergy + 0.5 * vbias) / kbT) + 1.0d0)          !FD at E+
                        fdminus = 1.0d0 / (exp((ienergy - 0.5 * vbias) / kbT) + 1.0d0)          !FD at E-
                        dfd(ifd)= abs(fdminus - fdplus)
!			if(real(vbias) .eq. real(1.0d0)) write(20, *) real(ienergy), real(dfd(ifd))
                end do        !ifd
                
                imid = int(nfd /2) + 1
                !------------------------------------------------------------------------------------------------------   
                ictr = 0
                ifd  = 0
                do idata=1, ndata
                        ien     = en(ivolt, idata)
                        if((ien .lt. -1.7d0) .or. (ien .gt. -0.3)) cycle
                        ictr   = ictr +1
                        f0     = 0.0d0                                      !Simpson's integration
                        fn     = 0.0d0
                        sum_0n = f0 + fn
                        sumevn = 0.0d0
                        sumodd = 0.0d0
                        jctr   = 0
                        do iint= idata, ndata                               !idata to ndata
                                if((real(ien) .eq. real(0.0d0)) .and. (real(vbias) .eq. real(0.8d0))) then
                                        write(11, *)  real(en(ivolt, iint)), real(trans(ivolt, iint)), real(dfd(imid + jctr))
                                end if  !if	
                                if(mod(jctr, 2) .ne. 0) then
                                        sumodd = sumodd + trans(ivolt, iint) * dfd(imid + jctr) 
                                else if(mod(jctr, 2) .eq. 0) then
                                        sumevn = sumevn + trans(ivolt, iint) * dfd(imid + jctr) 
                                else
                                        print*,"unknown err2"
                                end if  !mod
                                jctr = jctr + 1
                        end do  !iint

                        kctr  = 1
                        do iint= idata-1, 0, -1                                 !idata-1 to 0                    
                                if((real(ien) .eq. real(0.0d0)) .and. (real(vbias) .eq. real(0.8d0))) then
                                        write(11, *)  real(en(ivolt, iint)), real(trans(ivolt, iint)), real(dfd(imid - kctr))
                                end if  !if	
                                if(mod(kctr, 2) .ne. 0) then
                                        sumodd = sumodd + trans(ivolt, iint) * dfd(imid - kctr)
                                else if(mod(kctr, 2) .eq. 0) then
                                        sumevn = sumevn + trans(ivolt, iint) * dfd(imid - kctr)
                                else
                                        print*,"unknown err3"
                                end if  !mod
                                kctr = kctr + 1
                        end do  !iint
                                                                                                                                                                          
                        integral= sum_0n + 4.0d0 * sumodd + 2.0d0 * sumevn
                        interval= en(ivolt, 2) - en(ivolt, 1)
                        current(ivolt, idata) = integral * interval/ 3.0d0

                        write(unt3, *) en(ivolt, idata), volt(ivolt, idata), current(ivolt, idata)      		   !current

                        write(unt4, *) en(ivolt, idata), volt(ivolt, idata), current(ivolt, idata)/volt(ivolt, idata)      !G =I/V
                        if((real(en(ivolt, idata)) .ge. -1.5) .and. (real(en(ivolt, idata)) .le. -0.5)) then
                                if(mod(idata, 4) .eq. 0) then
                                        if(real(volt(ivolt, idata)) .ne. real(0.0)) then 
                            write(4, *) en(ivolt, idata), volt(ivolt, idata), current(ivolt, idata)/volt(ivolt, idata)
                                        end if !if
                                        write(3, *) en(ivolt, idata), volt(ivolt, idata), current(ivolt, idata)
                                end if  !if
                        end if          !if                                
                end do                  !idata
        end do  !ivolt

        print*,"Current...done!"

        do ivolt=3, nvolt-2
                interval= volt(ivolt, ndata) - volt(ivolt-1, ndata)
                write(5, *)
                unt5 = unt5 + 1
                open(unt5, file=trim(fdiff_g(ivolt)),  action="write")
                do idata=1, ndata
                        g = (current(ivolt+2, idata) + 8.0d0 * current(ivolt+1, idata) - 8.0d0 * current(ivolt-1, idata) + current(ivolt-2, idata))/(12.0d0 * interval)                
                        write(unt5, *) en(ivolt, idata), volt(ivolt, idata), g                          !g=dI/dV
                        if((real(en(ivolt, idata)) .ge. -1.5) .and. (real(en(ivolt, idata)) .le. -0.5)) then
                                if(mod(idata, 4) .eq. 0) then
                                        write(5, *) en(ivolt, idata), volt(ivolt, idata), g
                                end if  !if
                        end if          !if                                
                end do  !idata
        end do          !ivolt
        print*,"G=I/V and g=dI/dV...done!"

        call system('python trans.py')
        call system('python current.py')
        call system('python g.py')
        call system('python diff-g.py')
        print*, "2D plots.....done!"
end program new
