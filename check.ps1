 Cargo.toml

[package]
name = rust__checker
version = 0.1.0
edition = 2025

[dependencies]
eframe = 0.28
egui_extras = 0.28
rand = 0.8
rodio = 0.17


use eframeegui;
use egui{Color32, RichText, Sense, Stroke, Vec2};
use randRng;
use rodio{Decoder, OutputStream, Sink};
use stdioCursor;
use stdtime{Duration, Instant};

const CHECKER_SOUND &[u8] = include_bytes!(checker_sound.mp3);  положи любой звук античита (например из CSCOD)

struct Checker {
    stage u8,
    progress f32,
    start_time Instant,
    messages VecString,
    detected bool,
    sink Sink,
    _stream OutputStream,
}

impl FakeChecker {
    fn new(cc &eframeCreationContext'_) - Self {
        let (stream, stream_handle) = OutputStreamtry_default().unwrap();
        let sink = Sinktry_new(&stream_handle).unwrap();

         Загружаем звук (можно заменить на свой)
        let cursor = Cursornew(CHECKER_SOUND);
        let source = Decodernew(cursor).unwrap();
        sink.append(source);
        sink.set_volume(0.4);
        sink.play();

        Self {
            stage 0,
            progress 0.0,
            start_time Instantnow(),
            messages vec![],
            detected false,
            sink,
            _stream stream,
        }
    }

    fn fake_scan(&mut self, ui &mut eguiUi) {
        let elapsed = self.start_time.elapsed().as_secs_f32();

        match self.stage {
            0 = {
                self.messages.push(Инициализация античит системы....to_string());
                self.progress = (elapsed  2.0).min(1.0);
                if elapsed  2.0 { self.stage = 1; self.progress = 0.0; self.start_time = Instantnow(); }
            }

impl eframeApp for Checker {
    fn update(&mut self, ctx &eguiContext, _frame &mut eframeFrame) {
        ctx.request_repaint_after(Durationfrom_millis(50));

        eguiCentralPaneldefault().show(ctx, ui {
            ui.vertical_centered(ui {
                ui.add_space(60.0);

                 Логотип античита
                ui.heading(RichTextnew(RUST ANTI-CHEAT SYSTEM).size(42.0).color(Color32from_rgb(255, 50, 50)));
                ui.label(RichTextnew(Версия 7.4.1  Защита VAC-level).size(18.0).color(Color32LIGHT_GRAY));

                ui.add_space(40.0);

                 Прогресс бар
                let progress_bar = eguiProgressBarnew(self.progress)
                    .desired_width(600.0)
                    .height(30.0)
                    .fill(if self.detected { Color32from_rgb(255, 0, 0) } else { Color32from_rgb(0, 255, 100) })
                    .text(if self.detected {
                        Нарушений не обнаружено!
                    } else {
                        format!(Сканирование {.0}%, self.progress  100.0)
                    });

                ui.add(progress_bar);

                ui.add_space(30.0);

                 Логи
                eguiScrollAreavertical()
                    .max_height(300.0)
                    .show(ui, ui {
                        for msg in &self.messages {
                            let color = if msg.contains(ОБНАРУЖЕН)  msg.contains(ВНИМАНИЕ) {
                                Color32from_rgb(255, 80, 80)
                            } else if msg.contains(подозрительные) {
                                Color32YELLOW
                            } else {
                                Color32LIGHT_GREEN
                            };

                            ui.label(RichTextnew(msg).size(18.0).color(color).monospace());
                        }
                    });

                if self.detected {
                    ui.add_space(30.0);
                    ui.horizontal(ui {
                        if ui.add_sized([200.0, 60.0], eguiButtonnew(RichTextnew(ЗАКРЫТЬ ИГРУ).size(24.0)).fill(Color32DARK_RED)).clicked() {
                            stdprocessexit(0);
                        }
                        ui.add_space(20.0);
                        if ui.add_sized([200.0, 60.0], eguiButtonnew(RichTextnew(Я НЕ ЧИТЕР!)).fill(Color32DARK_GRAY)).clicked() {
                            self.messages.push(Ложь обнаружена. Бан через 3... 2... 1....to_string());
                        }
                    });
                }
            });

            self.fake_scan(ui);
        });

         Фон с мерцанием при детекте
        if self.detected {
            let paint = ctx.input(i i.time);
            let alpha = ((paint  4.0).sin()  50.0 + 50.0) as u8;
            ctx.set_pixels_per_point(1.0);
            eguiPainternew(ctx, ui.layer_id(), ui.available_rect_before_wrap())
                .rect_filled(ctx.screen_rect(), Color32from_black_alpha(alpha));
        }
    }
}

fn main() {
    let options = eframeNativeOptions {
        viewport eguiViewportBuilderdefault()
            .with_fullscreen(true)
            .with_resizable(false)
            .with_decorations(false),
        ..Defaultdefault()
    };

    eframerun_native(
        Rust  Anti-Cheat,
        options,
        Boxnew(cc {
            cc.egui_ctx.set_visuals(eguiVisualsdark());
            Boxnew(Checkernew(cc))
        }),
    ).unwrap();
}